USE QLHV
GO


CREATE TABLE GIAOVIEN(
    MAGV CHAR(4) PRIMARY KEY,
    HOTEN VARCHAR(40),
    HOCVI VARCHAR(10),
    HOCHAM VARCHAR(10),
    GIOITINH VARCHAR(3),
    NGSINH SMALLDATETIME,
    NGVL SMALLDATETIME,
    HESO NUMERIC(4,2),
    MUCLUONG MONEY,
    MAKHOA VARCHAR(4),
);


CREATE TABLE LOP(
    MALOP CHAR(3) PRIMARY KEY,
    TENLOP VARCHAR(40),
    TRGLOP CHAR(5),
    SISO TINYINT,
    MAGVCN CHAR(4) REFERENCES GIAOVIEN(MAGV),
);

CREATE TABLE HOCVIEN(
    MAHV CHAR(5) PRIMARY KEY,
    HO VARCHAR(40),
    TEN VARCHAR(10),
    NGSINH SMALLDATETIME,
    GIOITINH VARCHAR(3),
    NOISINH VARCHAR(40),
    MALOP CHAR(3) REFERENCES LOP(MALOP),
);

CREATE TABLE KHOA(
    MAKHOA VARCHAR(4) PRIMARY KEY,
    TENKHOA VARCHAR(40),
    NGTLAP SMALLDATETIME,
    TRGKHOA CHAR(4) REFERENCES GIAOVIEN(MAGV),
);

CREATE TABLE MONHOC(
    MAMH VARCHAR(10) PRIMARY KEY,
    TENMH VARCHAR(40),
    TCLT TINYINT,
    TCTH TINYINT,
    MAKHOA VARCHAR(4) REFERENCES KHOA(MAKHOA),
);

CREATE TABLE DIEUKIEN(
    MAMH VARCHAR(10) REFERENCES MONHOC(MAMH),
    MAMH_TRUOC VARCHAR(10) REFERENCES MONHOC(MAMH),
    PRIMARY KEY(MAMH, MAMH_TRUOC),
);

CREATE TABLE GIANGDAY(
    MALOP CHAR(3) REFERENCES LOP(MALOP),
    MAMH VARCHAR(10) REFERENCES MONHOC(MAMH),
    PRIMARY KEY(MALOP, MAMH),
    MAGV CHAR(4),
    HOCKY TINYINT,
    NAM SMALLINT,
    TUNGAY SMALLDATETIME,
    DENNGAY SMALLDATETIME,
);

CREATE TABLE KETQUATHI(
    MAHV CHAR(5) REFERENCES HOCVIEN(MAHV),
    MAMH VARCHAR(10) REFERENCES MONHOC(MAMH),
    LANTHI TINYINT,
    PRIMARY KEY(MAHV, MAMH, LANTHI),
    NGTHI SMALLDATETIME,
    DIEM NUMERIC(4,2),
    KQUA VARCHAR(10),
);

ALTER TABLE GIAOVIEN
ADD CONSTRAINT FK_KHOA_TRGKHOA FOREIGN KEY (MAKHOA) 
REFERENCES KHOA(MAKHOA) 

ALTER TABLE HOCVIEN
ADD GHICHU VARCHAR(20)

ALTER TABLE HOCVIEN
ADD DIEMTB NUMERIC(4,2)

ALTER TABLE HOCVIEN
ADD XEPLOAI VARCHAR(20)

--3--
ALTER TABLE HOCVIEN
ADD CONSTRAINT CHECK_GIOITINH CHECK(GIOITINH IN('Nam', 'Nu'))

ALTER TABLE GIAOVIEN
ADD CONSTRAINT CHECK_GTGV CHECK(GIOITINH IN('Nam', 'Nu'))

--4--
ALTER TABLE KETQUATHI
ADD CONSTRAINT CHECK_DIEM CHECK((DIEM BETWEEN 0 AND 10) AND (DIEM = ROUND(DIEM, 2)))

--5--
ALTER TABLE KETQUATHI
ADD CONSTRAINT CHECK_KQ CHECK((KQUA='Dat' AND DIEM BETWEEN 5 AND 10) OR (KQUA='Khong dat' AND DIEM < 5))

--6--
ALTER TABLE KETQUATHI 
ADD CONSTRAINT CHECK_LAN CHECK( LANTHI<=3 )

--7--
ALTER TABLE GIANGDAY
ADD CONSTRAINT CHECK_HK CHECK(HOCKY BETWEEN 1 AND 3)

--8--
ALTER TABLE GIAOVIEN
ADD CONSTRAINT CHECK_HV CHECK(HOCVI IN('CN', 'KS', 'Ths', 'TS', 'PTS'))





