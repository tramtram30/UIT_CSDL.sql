-- 76. Liệt kê top 3 chuyên gia có nhiều kỹ năng nhất và số lượng kỹ năng của họ.
SELECT TOP 3 WITH TIES cg.HoTen, COUNT(cgkn.MaKyNang) AS SoLuongKyNang
FROM dbo.ChuyenGia_KyNang AS cgkn
JOIN dbo.ChuyenGia AS cg ON cg.MaChuyenGia = cgkn.MaChuyenGia
GROUP BY cg.HoTen
ORDER BY SoLuongKyNang DESC

-- 77. Tìm các cặp chuyên gia có cùng chuyên ngành và số năm kinh nghiệm chênh lệch không quá 2 năm.
SELECT * 
FROM dbo.ChuyenGia AS cg1
JOIN dbo.ChuyenGia AS cg2 ON cg1.ChuyenNganh = cg2.ChuyenNganh AND cg1.MaChuyenGia > cg2.MaChuyenGia
WHERE ABS(cg1.NamKinhNghiem - cg2.NamKinhNghiem) <= 2

-- 78. Hiển thị tên công ty, số lượng dự án và tổng số năm kinh nghiệm của các chuyên gia tham gia dự án của công ty đó.
SELECT 
    ct.TenCongTy,
    COUNT(DISTINCT da.MaDuAn) AS SoLuongDuAn,
    SUM(cg.NamKinhNghiem) AS TongSoNamKinhNghiem
FROM CongTy ct
JOIN DuAn da ON ct.MaCongTy = da.MaCongTy
JOIN ChuyenGia_DuAn cgda ON da.MaDuAn = cgda.MaDuAn
JOIN ChuyenGia cg ON cgda.MaChuyenGia = cg.MaChuyenGia
GROUP BY ct.TenCongTy;


-- 79. Tìm các chuyên gia có ít nhất một kỹ năng cấp độ 5 nhưng không có kỹ năng nào dưới cấp độ 3.
SELECT DISTINCT *
FROM ChuyenGia cg
JOIN ChuyenGia_KyNang cgkn ON cg.MaChuyenGia = cgkn.MaChuyenGia
WHERE EXISTS (
    SELECT 1
    FROM ChuyenGia_KyNang
    WHERE MaChuyenGia = cg.MaChuyenGia AND CapDo = 5
)
AND NOT EXISTS (
    SELECT 1
    FROM ChuyenGia_KyNang
    WHERE MaChuyenGia = cg.MaChuyenGia AND CapDo < 3
);


-- 80. Liệt kê các chuyên gia và số lượng dự án họ tham gia, bao gồm cả những chuyên gia không tham gia dự án nào.
SELECT cg.HoTen, COUNT(cgda.MaDuAn) AS SoLuongDuAn
FROM ChuyenGia cg
LEFT JOIN ChuyenGia_DuAn cgda ON cg.MaChuyenGia = cgda.MaChuyenGia
GROUP BY cg.HoTen;

-- 81*. Tìm chuyên gia có kỹ năng ở cấp độ cao nhất trong mỗi loại kỹ năng.
WITH XHKN AS (
SELECT MaChuyenGia, MaKyNang, CapDo,
RANK() OVER (PARTITION BY MaKyNang ORDER BY CapDo DESC) AS XH
FROM dbo.ChuyenGia_KyNang
)
SELECT MaChuyenGia, MaKyNang
FROM XHKN
WHERE XH = 1


-- 82. Tính tỷ lệ phần trăm của mỗi chuyên ngành trong tổng số chuyên gia.
SELECT ChuyenNganh, COUNT(*) AS SoLuongChuyenGia,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM ChuyenGia), 2) AS TiLePhanTram
FROM ChuyenGia
GROUP BY ChuyenNganh;

-- 83. Tìm các cặp kỹ năng thường xuất hiện cùng nhau nhất trong hồ sơ của các chuyên gia.
SELECT TOP 1 WITH TIES 
    K1.MaKyNang AS MaKyNang1, 
    K2.MaKyNang AS MaKyNang2, 
    COUNT(*) AS SoLanXuatHien
FROM dbo.ChuyenGia_KyNang AS K1
JOIN 
    dbo.ChuyenGia_KyNang AS K2 
    ON K1.MaChuyenGia = K2.MaChuyenGia AND K1.MaKyNang < K2.MaKyNang
GROUP BY K1.MaKyNang, K2.MaKyNang
ORDER BY SoLanXuatHien DESC;

-- 84. Tính số ngày trung bình giữa ngày bắt đầu và ngày kết thúc của các dự án cho mỗi công ty.
SELECT TenCongTy,
AVG(DATEDIFF(DAY, NgayBatDau, NgayKetThuc)) AS SoNgayTrungBinh
FROM dbo.CongTy 
JOIN dbo.DuAn 
    ON CongTy.MaCongTy = DuAn.MaCongTy
GROUP BY TenCongTy;

-- 85*. Tìm chuyên gia có sự kết hợp độc đáo nhất của các kỹ năng (kỹ năng mà chỉ họ có).
WITH COUNTSKILLS AS (
    SELECT MaKyNang, COUNT(MaKyNang) AS SoLuongKyNang
    FROM dbo.ChuyenGia_KyNang
    GROUP BY MaKyNang
    HAVING COUNT(MaKyNang) = 1
)

SELECT cg.MaChuyenGia, cg.HoTen
FROM dbo.ChuyenGia AS cg
JOIN dbo.ChuyenGia_KyNang AS K ON cg.MaChuyenGia = K.MaChuyenGia
WHERE K.MaKyNang IN (
    SELECT MaKyNang
    FROM COUNTSKILLS
);


-- 86*. Tạo một bảng xếp hạng các chuyên gia dựa trên số lượng dự án và tổng cấp độ kỹ năng.
SELECT cg.MaChuyenGia, HoTen, COUNT(DISTINCT cgda.MaDuAn) AS SoLuongDuAn, SUM(cgkn.CapDo) AS TongCapDoKyNang,
DENSE_RANK() OVER(ORDER BY COUNT(DISTINCT cgda.MaDuAn) DESC, SUM(cgkn.CapDo) DESC) AS XepHang
FROM dbo.ChuyenGia AS cg
JOIN dbo.ChuyenGia_KyNang AS cgkn ON cg.MaChuyenGia = cgkn.MaChuyenGia
JOIN dbo.ChuyenGia_DuAn AS cgda ON cg.MaChuyenGia = cgda.MaChuyenGia
GROUP BY cg.MaChuyenGia, HoTen
ORDER BY XepHang 


-- 87. Tìm các dự án có sự tham gia của chuyên gia từ tất cả các chuyên ngành.
SELECT MaDuAn
FROM dbo.ChuyenGia_DuAn AS cgda
JOIN dbo.ChuyenGia AS cg ON cg.MaChuyenGia = cgda.MaChuyenGia
GROUP BY MaDuAn
HAVING COUNT(DISTINCT cg.ChuyenNganh) = (
	SELECT COUNT(DISTINCT ChuyenNganh) AS SoLuongChuyenNganh
	FROM dbo.ChuyenGia
)


-- 88. Tính tỷ lệ thành công của mỗi công ty dựa trên số dự án hoàn thành so với tổng số dự án.
SELECT ct.MaCongTy, ct.TenCongTy,
    COUNT(CASE WHEN da.TrangThai = N'Hoàn thành' THEN 1 END) * 1.0 / COUNT(da.MaDuAn) AS TyLeThanhCong
FROM dbo.CongTy AS ct
JOIN dbo.DuAn AS da ON ct.MaCongTy = da.MaCongTy
GROUP BY ct.MaCongTy, ct.TenCongTy
ORDER BY TyLeThanhCong DESC;


-- 89. Tìm các chuyên gia có kỹ năng "bù trừ" nhau (một người giỏi kỹ năng A nhưng yếu kỹ năng B, người kia ngược lại).
SELECT cg1.MaChuyenGia AS ChuyenGia1,
    cg2.MaChuyenGia AS ChuyenGia2,
    cg1.MaKyNang,
    cg1.CapDo AS CapDo_ChuyenGia1,
    cg2.CapDo AS CapDo_ChuyenGia2
FROM dbo.ChuyenGia_KyNang AS cg1 
JOIN dbo.ChuyenGia_KyNang AS cg2
ON cg1.MaKyNang = cg2.MaKyNang
   AND cg1.MaChuyenGia < cg2.MaChuyenGia
WHERE (cg1.CapDo > cg2.CapDo AND cg1.CapDo >= 4 AND cg2.CapDo <= 3)
     OR (cg1.CapDo < cg2.CapDo AND cg1.CapDo <= 3 AND cg2.CapDo >= 4);