USE QLBH
GO

CREATE TABLE KHACHHANG(
    MAKH CHAR(4) PRIMARY KEY,
    HOTEN VARCHAR(40),
    DCHI VARCHAR(50),
    SODT VARCHAR(20),
    NGSINH SMALLDATETIME,
    NGDK SMALLDATETIME,
    DOANHSO MONEY,
);

CREATE TABLE NHANVIEN(
    MANV CHAR(4) PRIMARY KEY,
    HOTEN VARCHAR(40),
    SODT VARCHAR(20),
    NGVL SMALLDATETIME,
);

CREATE TABLE SANPHAM(
    MASP CHAR(4) PRIMARY KEY,
    TENSP VARCHAR(40),
    DVT VARCHAR(20),
    NUOCSX VARCHAR(40),
    GIA MONEY,
);

CREATE TABLE HOADON(
    SOHD INT PRIMARY KEY,
    NGHD SMALLDATETIME,
    MAKH CHAR(4) REFERENCES KHACHHANG(MAKH),
    MANV CHAR(4) REFERENCES NHANVIEN(MANV),
    TRIGIA MONEY,
);

CREATE TABLE CTHD(
    SOHD INT REFERENCES HOADON(SOHD),
    MASP CHAR(4) REFERENCES SANPHAM(MASP),
    PRIMARY KEY(SOHD, MASP), 
    SL INT,
);

ALTER TABLE SANPHAM
ADD GHICHU VARCHAR(20)

ALTER TABLE KHACHHANG
ADD LOAIKH TINYINT

ALTER TABLE SANPHAM
ALTER COLUMN GHICHU VARCHAR(100)

ALTER TABLE SANPHAM
DROP COLUMN GHICHU

--6--
ALTER TABLE KHACHHANG ALTER COLUMN LOAIKH VARCHAR(20)
ALTER TABLE KHACHHANG ADD CONSTRAINT CHECK_LOAIKH CHECK(LOAIKH IN('Vang lai', 'Thuong xuyen', 'VIP'))

--7--
ALTER TABLE SANPHAM
ADD CONSTRAINT CHECK_DVT CHECK(DVT IN('cay', 'hop', 'cai', 'quyen', 'chuc'))

--8--
ALTER TABLE SANPHAM
ADD CONSTRAINT CHECK_GIA CHECK(GIA >= 500)

--9--
ALTER TABLE HOADON
ADD CONSTRAINT CHECK_SOHD CHECK(SOHD >= 1)

--10--
ALTER TABLE KHACHHANG
ADD CONSTRAINT CHECK_NG CHECK(NGDK > NGSINH)






