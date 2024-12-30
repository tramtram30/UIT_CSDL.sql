CREATE DATABASE DE02
GO

USE DE02 
GO

--1--
CREATE TABLE NHANVIEN (
	MaNV char(5) primary key,
	HoTen varchar(20),
	NgayVL smalldatetime,
	HSLuong numeric(4,2),
	MaPhong char(5),
);

CREATE TABLE PHONGBAN (
	MaPhong char(5) primary key,
	TenPhong varchar(25),
	TruongPhong char(5) foreign key references NHANVIEN(MaNV),
);

CREATE TABLE XE (
	MaXe char(5) primary key,
	LoaiXe varchar(20),
	SoChoNgoi int,
	NamSX int,
);

CREATE TABLE PHANCONG (
	MaPC char(5) primary key,
	MaNV char(5) foreign key references NHANVIEN(MaNV),
	MaXe char(5) foreign key references XE(MaXe),
	NgayDi smalldatetime,
	NgayVe smalldatetime,
	NoiDen varchar(25),
);

ALTER TABLE NHANVIEN
ADD CONSTRAINT FK_NV_PB FOREIGN KEY (MaPhong) REFERENCES PHONGBAN(MaPhong);

--2.1--
ALTER TABLE XE 
ADD CONSTRAINT CHECK_NSX
CHECK ((LoaiXe = 'Toyota') AND NamSX >= 2006);

--2.2--
CREATE TRIGGER TRG_INS_UPD_PC
ON dbo.PHANCONG
FOR INSERT, UPDATE
AS
BEGIN
	IF EXISTS (
		SELECT *
		FROM inserted I
		JOIN dbo.XE AS X ON X.MaXe = I.MaXe
		JOIN dbo.NHANVIEN AS NV ON NV.MaNV = I.MaNV
		JOIN dbo.PHONGBAN AS PB ON PB.MaPhong = NV.MaPhong	
		WHERE TenPhong = N'Ngoại thành' AND LoaiXe = 'Toyota'
	)
	BEGIN
		RAISERROR('Nhân viên thuộc phòng lái xe “Ngoại thành” chỉ được phân công lái xe loại Toyota',16,1)
		ROLLBACK TRAN
	END
END;
GO

--3.1--
SELECT NV.MaNV, HoTen
FROM dbo.NHANVIEN AS NV
JOIN dbo.PHONGBAN AS PB ON NV.MaPhong = NV.MaPhong
JOIN dbo.PHANCONG AS PC ON PC.MaNV = NV.MaNV
JOIN dbo.XE AS X ON X.MaXe = PC.MaXe
WHERE TenPhong = N'Nội thành' AND SoChoNgoi = 4

--3.2--
SELECT NV.MaNV, HoTen
FROM dbo.NHANVIEN AS NV
JOIN dbo.PHONGBAN AS PB ON NV.MaNV = PB.TruongPhong
WHERE NOT EXISTS (
	SELECT *
	FROM dbo.XE AS X
	WHERE NOT EXISTS (
		SELECT *
		FROM dbo.PHANCONG AS PC
		WHERE PC.MaNV = NV.MaNV
			AND PC.MaXe = X.MaXe
	)
)

--3.3--
SELECT NV1.MaNV, HoTen
FROM dbo.NHANVIEN AS NV1
JOIN dbo.PHONGBAN AS PB ON NV1.MaPhong = PB.MaPhong
WHERE NV1.MaNV IN (
	SELECT TOP 1 WITH TIES NV2.MaNV
	FROM dbo.NHANVIEN AS NV2
	JOIN dbo.PHANCONG AS PC ON NV2.MaNV = PC.MaNV
	JOIN dbo.XE AS X ON X.MaXe = PC.MaXe
	WHERE LoaiXe = 'Toyota' AND NV1.MaPhong = NV2.MaPhong
	GROUP BY NV2.MaNV, HoTen
	ORDER BY COUNT(*) ASC
)