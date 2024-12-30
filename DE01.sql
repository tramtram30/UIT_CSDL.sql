CREATE DATABASE DE01
GO 

USE DE01 
GO

CREATE TABLE TACGIA (
	MaTG char(5) primary key,
	HoTen varchar(20),
	DiaChi varchar(50),
	NgSinh smalldatetime,
	SoDT varchar(15),
);

CREATE TABLE SACH (
	MaSach char(5) primary key,
	TenSach varchar(25),
	TheLoai varchar(25),
);

CREATE TABLE TACGIA_SACH (
	MaTG char(5) foreign key references TACGIA(MaTG),
	MaSach char(5) foreign key references SACH(MaSach),
	Primary key(MaTG, MaSach),
);

CREATE TABLE PHATHANH (
	MaPH char(5) primary key,
	MaSach char(5) foreign key references SACH(MaSach),
	NgayPH smalldatetime,
	SoLuong int,
	NhaXuatBan varchar(20),
);

--2.1--
CREATE TRIGGER TRG_INS_UDP_PHATHANH
ON dbo.PHATHANH
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @MaSach CHAR(5), @NGSINH SMALLDATETIME, @NGPH SMALLDATETIME

	SELECT @MaSach = MaSach, @NGPH = NgayPH
	FROM inserted

	SELECT @NGSINH = NgSinh
	FROM dbo.TACGIA AS TG
	JOIN dbo.TACGIA_SACH AS TGS ON TG.MaTG = TGS.MaTG
	WHERE MaSach = @MaSach

	IF (@NGSINH > @NGPH)
	BEGIN
		RAISERROR('NGPH PHAI > NGSINH',16,1)
		ROLLBACK TRAN
	END
	ELSE 
	BEGIN
		PRINT 'THANH CONG'
	END
END
GO

CREATE TRIGGER TRG_UPD_TG
ON dbo.TACGIA
FOR UPDATE
AS
BEGIN
	DECLARE @MaTG CHAR(5), @NGSINH SMALLDATETIME, @NGPH SMALLDATETIME

	SELECT @NGSINH = NgSinh, @MaTG = MaTG
	FROM inserted

	SELECT @NGPH = MIN(NgayPH)
	FROM dbo.TACGIA_SACH AS TGS
	JOIN dbo.PHATHANH AS PH ON TGS.MaSach = PH.MaSach
	WHERE MaTG = @MaTG

	IF (@NGSINH > @NGPH)
	BEGIN
		RAISERROR('NGPH PHAI > NGSINH',16,1)
		ROLLBACK TRAN
	END
	ELSE 
	BEGIN
		PRINT 'THANH CONG'
	END
END
GO

--2.2--
CREATE TRIGGER TRG_INS_UPD_PHSACH
ON dbo.PHATHANH
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @MaSach CHAR(5), @TheLoai VARCHAR(25), @NXB VARCHAR(25)

	SELECT @MaSach = MaSach, @NXB = NhaXuatBan
	FROM inserted

	SELECT @TheLoai = TheLoai
	FROM dbo.SACH
	WHERE MaSach = @MaSach

	IF (@TheLoai = 'Giáo Khoa' AND @NXB <> 'Giáo dục')
	BEGIN
		RAISERROR('Sách thuộc thể loại “Giáo khoa” chỉ do nhà xuất bản “Giáo dục” phát hành',16,1)
		ROLLBACK TRAN
	END
	ELSE
	BEGIN
		PRINT 'THANH CONG'
	END
END
GO

CREATE TRIGGER TRG_TL_NXB_SACH
ON dbo.SACH
FOR UPDATE
AS
BEGIN
	DECLARE @MaSach CHAR(5), @TheLoai VARCHAR(25), @NXB VARCHAR(25)

	SELECT @MaSach = MaSach, @TheLoai = TheLoai
	FROM inserted

	SELECT @NXB = NhaXuatBan
	FROM dbo.PHATHANH
	WHERE MaSach = @MaSach

	IF (@TheLoai = 'Giáo Khoa' AND @NXB <> 'Giáo dục')
	BEGIN
		RAISERROR('Sách thuộc thể loại “Giáo khoa” chỉ do nhà xuất bản “Giáo dục” phát hành',16,1)
		ROLLBACK TRAN
	END
	ELSE
	BEGIN
		PRINT 'THANH CONG'
	END
END
GO

--3.1--
SELECT TG.MaTG, HoTen, SoDT
FROM dbo.SACH AS S
JOIN dbo.PHATHANH AS PH ON S.MaSach = PH.MaSach
JOIN dbo.TACGIA_SACH AS TGS ON TGS.MaSach = S.MaSach
JOIN dbo.TACGIA AS TG ON TG.MaTG = TGS.MaTG
WHERE TheLoai = N'Văn học' AND NhaXuatBan = N'Trẻ'

--3.2--
SELECT TOP 1 WITH TIES NhaXuatBan 
FROM dbo.PHATHANH AS PH 
JOIN dbo.SACH AS S ON PH.MaSach = S.MaSach
GROUP BY NhaXuatBan
ORDER BY COUNT(DISTINCT TheLoai) DESC

--3.3--
SELECT NhaXuatBan, tg.MaTG, HoTen, SoDT
FROM dbo.PHATHANH AS PH1
JOIN dbo.TACGIA_SACH AS tgs ON PH1.MaSach = tgs.MaSach
JOIN dbo.TACGIA AS tg ON tg.MaTG = tgs.MaTG
WHERE tg.MaTG IN(
	SELECT TOP 1 WITH TIES TG.MaTG
	FROM dbo.TACGIA AS TG
	JOIN dbo.TACGIA_SACH AS TGS ON TG.MaTG = TGS.MaTG
	JOIN dbo.PHATHANH AS PH2 ON PH2.MaSach = TGS.MaSach
	WHERE PH2.NhaXuatBan = PH1.NhaXuatBan
	GROUP BY TG.MaTG, SoLuong
	ORDER BY SoLuong DESC
)