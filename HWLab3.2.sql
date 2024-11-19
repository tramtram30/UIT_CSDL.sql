--1. Hiển thị tên và cấp độ của tất cả các kỹ năng của chuyên gia có MaChuyenGia là 1, đồng thời lọc ra những kỹ năng có cấp độ thấp hơn 3.
SELECT kn.TenKyNang, cgkn.CapDo
FROM ChuyenGia_KyNang cgkn
JOIN KyNang kn ON cgkn.MaKyNang = kn.MaKyNang
WHERE cgkn.MaChuyenGia = 1 AND cgkn.CapDo >=3;

--2. Liệt kê tên các chuyên gia tham gia dự án có MaDuAn là 2 và có ít nhất 2 kỹ năng khác nhau.
SELECT  cg.HoTen
FROM ChuyenGia cg
JOIN ChuyenGia_DuAn cgda ON cg.MaChuyenGia = cgda.MaChuyenGia
JOIN (
    SELECT MaChuyenGia
    FROM ChuyenGia_KyNang cgkn
    GROUP BY MaChuyenGia
    HAVING COUNT(DISTINCT MaKyNang) >= 2
) cgkn ON cg.MaChuyenGia = cgkn.MaChuyenGia
WHERE cgda.MaDuAn = 2;

--3. Hiển thị tên công ty và tên dự án của tất cả các dự án, sắp xếp theo tên công ty và số lượng chuyên gia tham gia dự án.
SELECT ct.TenCongTy, da.TenDuAn
FROM CongTy ct
JOIN DuAn da ON ct.MaCongTy = da.MaCongTy
JOIN ChuyenGia_DuAn cgda ON da.MaDuAn = cgda.MaDuAn
GROUP BY ct.TenCongTy, da.TenDuAn
ORDER BY ct.TenCongTy, COUNT (cgda.MaChuyenGia) DESC


--4. Đếm số lượng chuyên gia trong mỗi chuyên ngành và hiển thị chỉ những chuyên ngành có hơn 5 chuyên gia.
SELECT ChuyenNganh, COUNT(*) AS SoLuongChuyenGia
FROM ChuyenGia
GROUP BY ChuyenNganh
HAVING COUNT(*) > 5;

--5. Tìm chuyên gia có số năm kinh nghiệm cao nhất và hiển thị cả danh sách kỹ năng của họ.
 SELECT cg.HoTen, cg.NamKinhNghiem, kn.TenKyNang
 FROM ChuyenGia cg
 JOIN ChuyenGia_KyNang cgkn ON cg.MaChuyenGia = cgkn.MaChuyengia
 JOIN KyNang kn ON cgkn.MaKyNang = kn.MaKyNang
 WHERE cg.NamKinhNghiem = (
    SELECT MAX (NamKinhNghiem) FROM ChuyenGia
 );

--6. Liệt kê tên các chuyên gia và số lượng dự án họ tham gia, đồng thời tính toán tỷ lệ phần trăm so với tổng số dự án trong hệ thống.
 SELECT
       cg.HOten,
       COUNT (cgda.MaDuAn) AS SoLuongDuAnThamGia,
       ROUND ((Count(cgda.MaDuAn) * 100.0 / (SELECT COUNT(*) FROM DuAn)), 2) AS TyLe
 FROM ChuyenGia cg
 JOIN ChuyenGia_DuAn cgda ON cg.MaChuyenGia = cgda.MaChuyenGia
 GROUP BY cg.HoTen
 ORDER BY SoLuongDuAnThamGia DESC;

--7. Hiển thị tên công ty và số lượng dự án của mỗi công ty, bao gồm cả những công ty không có dự án nào.
 SELECT 
       ct.TenCongTy,
       COUNT(da.MaDuAn) AS SoLuongDuAn
 FROM CongTy ct
 LEFT JOIN DuAn da ON ct.MaCongTy = da.MaCongTy
 GROUP BY ct.TenCongTy
 ORDER BY SoLuongDuAn DESC;

--8. Tìm kỹ năng được sở hữu bởi nhiều chuyên gia nhất, đồng thời hiển thị số lượng chuyên gia sở hữu kỹ năng đó.
SELECT 
    kn.TenKyNang,
    COUNT(cgkn.MaChuyenGia) AS SoLuongChuyenGia
FROM KyNang kn
JOIN ChuyenGia_KyNang cgkn ON kn.MaKyNang = cgkn.MaKyNang
GROUP BY kn.TenKyNang
ORDER BY SoLuongChuyenGia DESC
--9. Liệt kê tên các chuyên gia có kỹ năng 'Python' với cấp độ từ 4 trở lên, đồng thời tìm kiếm những người cũng có kỹ năng 'Java'.
 SELECT cg.HoTen
 FROM ChuyenGia cg
 JOIN ChuyenGia_KyNang cgkn1 ON cg.MaChuyenGia = cgkn1.MaChuyenGia
 JOIN KyNang kn1 ON cgkn1.MaKyNang = kn1.MaKyNang
 JOIN ChuyenGia_KyNang cgkn2 ON cg.MaChuyenGia = cgkn2.MaChuyenGia
 JOIN KyNang kn2 ON cgkn2.MaKyNang = kn2.MaKyNang
 WHERE 
    kn1.TenKyNang = 'Python' AND cgkn1.CapDo >= 4
    AND kn2.TenKyNang = 'Java';

--10. Tìm dự án có nhiều chuyên gia tham gia nhất và hiển thị danh sách tên các chuyên gia tham gia vào dự án đó.
 SELECT da.TenDuAn, cg.HoTen
 FROM DuAn da
 JOIN ChuyenGia_DuAn cgda ON da.MaDuAn = cgda.MaDuAn
 JOIN ChuyenGia cg ON cgda.MaChuyenGia = cg.MaChuyenGia
 WHERE da.MaDuAn = (
    SELECT TOP 1 cgda1.MaDuAn
    FROM ChuyenGia_DuAn cgda1
    GROUP BY cgda1.MaDuAn
    ORDER BY COUNT(cgda1.MaChuyenGia) DESC
 );

--11. Hiển thị tên và số lượng kỹ năng của mỗi chuyên gia, đồng thời lọc ra những người có ít nhất 5 kỹ năng.
 SELECT cg.HoTen, COUNT(cgkn.MaKyNang) AS SoLuongKyNang
 FROM ChuyenGia cg
 JOIN ChuyenGia_KyNang cgkn ON cg.MaChuyenGia = cgkn.MaChuyenGia
 GROUP BY cg.HoTen
 HAVING COUNT(cgkn.MaKyNang) >= 5;

--12. Tìm các cặp chuyên gia làm việc cùng dự án và hiển thị thông tin về số năm kinh nghiệm của từng cặp.
 SELECT 
       cg1.HoTen AS ChuyenGia1,
       cg2.HoTen AS ChuyenGia2,
       da.TenDuAn,
       cg1.NamKinhNghiem AS KinhNghiem_ChuyenGia1,
       cg2.NamKinhNghiem AS KinhNghiem_ChuyenGia2
 FROM ChuyenGia cg1
 JOIN ChuyenGia_DuAn cgda1 ON cg1.MaChuyenGia = cgda1.MaChuyenGia
 JOIN DuAn da ON cgda1.MaDuAn = da.MaDuAn
 JOIN ChuyenGia_DuAn cgda2 ON da.MaDuAn = cgda2.MaDuAn
 JOIN ChuyenGia cg2 ON cgda2.MaChuyenGia = cg2.MaChuyenGia
 WHERE cg1.MaChuyenGia < cg2.MaChuyenGia;      

--13. Liệt kê tên các chuyên gia và số lượng kỹ năng cấp độ 5 của họ, đồng thời tính toán tỷ lệ phần trăm so với tổng số kỹ năng mà họ sở hữu.
 SELECT 
       cg.HoTen,
       COUNT (cgkn.MaKyNang) AS SoLuongKyNangC5,
       (COUNT (cgkn.MaKyNang) * 100.0 / (
        SELECT COUNT (*) FROM ChuyenGia_KyNang WHERE MaChuyenGia = cg.MaChuyenGia))
       AS TyLeKyNangC5
 FROM ChuyenGia cg
 JOIN ChuyenGia_KyNang cgkn ON cg.MaChuyenGia = cgkn.MaChuyenGia
 WHERE cgkn.CapDo = 5
 GROUP BY cg.HoTen, cg.MaChuyenGia;

--14. Tìm các công ty không có dự án nào và hiển thị cả thông tin về số lượng nhân viên trong mỗi công ty đó.
 SELECT ct.TenCongTy, ct.SoNhanVien
 FROM CongTy ct
 LEFT JOIN DuAn da ON ct.MaCongTy = da.MaCongTy
 WHERE da.MaDuAn IS NULL;

--15. Hiển thị tên chuyên gia và tên dự án họ tham gia, bao gồm cả những chuyên gia không tham gia dự án nào, sắp xếp theo tên chuyên gia.
 SELECT cg.HoTen AS ChuyenGia, da.TenDuAn
 FROM ChuyenGia cg
 LEFT JOIN
  ChuyenGia_DuAn cgda ON cg.MaChuyenGia = cgda.MaChuyenGia
 LEFT JOIN
  DuAn da ON cgda.MaDuAn = da.MaDuAn
 ORDER BY cg.HoTen;

--16. Tìm các chuyên gia có ít nhất 3 kỹ năng, đồng thời lọc ra những người không có bất kỳ kỹ năng nào ở cấp độ cao hơn 3.
SELECT CG.MaChuyenGia, CG.HoTen
FROM ChuyenGia CG
JOIN ChuyenGia_KyNang CK ON CG.MaChuyenGia = CK.MaChuyenGia
JOIN ChuyenGia_DuAn CD ON CG.MaChuyenGia = CD.MaChuyenGia
WHERE CK.CapDo <= 3;


--17. Hiển thị tên công ty và tổng số năm kinh nghiệm của tất cả chuyên gia trong các dự án của công ty đó, chỉ hiển thị những công ty có tổng số năm kinh nghiệm lớn hơn 10 năm.
SELECT 
    ct.TenCongTy,
    SUM(cg.NamKinhNghiem) AS TongNamKinhNghiem
FROM CongTy ct
JOIN DuAn da ON ct.MaCongTy = da.MaCongTy
JOIN ChuyenGia_DuAn cgda ON da.MaDuAn = cgda.MaDuAn
JOIN ChuyenGia cg ON cgda.MaChuyenGia = cg.MaChuyenGia
GROUP BY ct.TenCongTy
HAVING SUM(cg.NamKinhNghiem) > 10;

--18. Tìm các chuyên gia có kỹ năng 'Java' nhưng không có kỹ năng 'Python', đồng thời hiển thị danh sách các dự án mà họ đã tham gia.
SELECT 
    cg.HoTen,
    da.TenDuAn
FROM ChuyenGia cg
JOIN ChuyenGia_KyNang cgkn ON cg.MaChuyenGia = cgkn.MaChuyenGia
JOIN KyNang kn1 ON cgkn.MaKyNang = kn1.MaKyNang AND kn1.TenKyNang = 'Java'
LEFT JOIN ChuyenGia_KyNang cgkn2 ON cg.MaChuyenGia = cgkn2.MaChuyenGia
LEFT JOIN KyNang kn2 ON cgkn2.MaKyNang = kn2.MaKyNang AND kn2.TenKyNang = 'Python'
LEFT JOIN ChuyenGia_DuAn cgda ON cg.MaChuyenGia = cgda.MaChuyenGia
LEFT JOIN DuAn da ON cgda.MaDuAn = da.MaDuAn
WHERE kn2.MaKyNang IS NULL 
ORDER BY cg.HoTen, da.TenDuAn;

--19. Tìm chuyên gia có số lượng kỹ năng nhiều nhất và hiển thị cả danh sách các dự án mà họ đã tham gia.
WITH SoLuongKyNang AS (
    SELECT 
        MaChuyenGia, 
        COUNT(*) AS SoKyNang
    FROM ChuyenGia_KyNang
    GROUP BY MaChuyenGia
),
ChuyenGiaNhieuKyNangNhat AS (
    SELECT 
        MaChuyenGia, 
        SoKyNang
    FROM SoLuongKyNang
    WHERE SoKyNang = (SELECT MAX(SoKyNang) FROM SoLuongKyNang)
)

SELECT 
    cg.HoTen,
    da.TenDuAn
FROM ChuyenGia cg
JOIN ChuyenGiaNhieuKyNangNhat cgnkn ON cg.MaChuyenGia = cgnkn.MaChuyenGia
LEFT JOIN ChuyenGia_DuAn cgda ON cg.MaChuyenGia = cgda.MaChuyenGia
LEFT JOIN DuAn da ON cgda.MaDuAn = da.MaDuAn
ORDER BY cg.HoTen, da.TenDuAn;

--20. Liệt kê các cặp chuyên gia có cùng chuyên ngành và hiển thị thông tin về số năm kinh nghiệm của từng người trong cặp đó.
SELECT 
    cg1.HoTen AS ChuyenGia1,
    cg1.ChuyenNganh AS ChuyenNganh,
    cg1.NamKinhNghiem AS NamKinhNghiem1,
    cg2.HoTen AS ChuyenGia2,
    cg2.NamKinhNghiem AS NamKinhNghiem2
FROM 
    ChuyenGia cg1
JOIN 
    ChuyenGia cg2 
ON 
    cg1.ChuyenNganh = cg2.ChuyenNganh
    AND cg1.MaChuyenGia != cg2.MaChuyenGia
ORDER BY 
    cg1.ChuyenNganh, cg1.HoTen, cg2.HoTen;

--21. Tìm công ty có tổng số năm kinh nghiệm của các chuyên gia trong dự án cao nhất và hiển thị danh sách tất cả các dự án mà công ty đó đã thực hiện.
WITH TotalExperience AS (
    SELECT 
        da.MaCongTy, 
        SUM(cg.NamKinhNghiem) AS TotalExperience
    FROM ChuyenGia cg
    JOIN ChuyenGia_DuAn cda ON cg.MaChuyenGia = cda.MaChuyenGia
    JOIN DuAn da ON cda.MaDuAn = da.MaDuAn
    GROUP BY da.MaCongTy
),
MaxExperience AS (
    SELECT MAX(TotalExperience) AS MaxExperience
    FROM TotalExperience
)
SELECT 
    ct.TenCongTy,
    da.TenDuAn
FROM TotalExperience te
JOIN MaxExperience me ON te.TotalExperience = me.MaxExperience
JOIN CongTy ct ON te.MaCongTy = ct.MaCongTy
JOIN DuAn da ON te.MaCongTy = da.MaCongTy
ORDER BY da.TenDuAn;

--22. Tìm kỹ năng được sở hữu bởi tất cả các chuyên gia và hiển thị danh sách chi tiết về từng chuyên gia sở hữu kỹ năng đó cùng với cấp độ của họ.
SELECT 
    kn.TenKyNang,
    cg.HoTen,
    cgn.CapDo
FROM KyNang kn
JOIN ChuyenGia_KyNang cgn ON kn.MaKyNang = cgn.MaKyNang
JOIN ChuyenGia cg ON cg.MaChuyenGia = cgn.MaChuyenGia
WHERE 
    NOT EXISTS (
        SELECT 1
        FROM ChuyenGia cg2
        WHERE NOT EXISTS (
            SELECT 1
            FROM ChuyenGia_KyNang cgn2
            WHERE cgn2.MaChuyenGia = cg2.MaChuyenGia
            AND cgn2.MaKyNang = kn.MaKyNang
        )
    )
ORDER BY 
    kn.TenKyNang, cg.HoTen;


--23. Tìm tất cả các chuyên gia có ít nhất 2 kỹ năng thuộc cùng một lĩnh vực và hiển thị tên chuyên gia cùng với tên lĩnh vực đó.
SELECT 
    cg.HoTen AS ChuyenGia,
    kn.LoaiKyNang AS LinhVuc
FROM ChuyenGia cg
JOIN ChuyenGia_KyNang cgn ON cg.MaChuyenGia = cgn.MaChuyenGia
JOIN KyNang kn ON kn.MaKyNang = cgn.MaKyNang
GROUP BY cg.MaChuyenGia, cg.HoTen, kn.LoaiKyNang
HAVING COUNT(DISTINCT kn.MaKyNang) >= 2
ORDER BY cg.HoTen;


--24. Hiển thị tên các dự án và số lượng chuyên gia tham gia cho mỗi dự án, chỉ hiển thị những dự án có hơn 3 chuyên gia tham gia.
SELECT 
    da.TenDuAn AS DuAn,
    COUNT(cga.MaChuyenGia) AS SoLuongChuyenGia
FROM 
    DuAn da
JOIN 
    ChuyenGia_DuAn cga ON da.MaDuAn = cga.MaDuAn
GROUP BY 
    da.MaDuAn, da.TenDuAn
HAVING 
    COUNT(cga.MaChuyenGia) > 3
ORDER BY 
    SoLuongChuyenGia DESC;

  
--25.Tìm công ty có số lượng dự án lớn nhất và hiển thị tên công ty cùng với số lượng dự án.
SELECT 
    ct.TenCongTy AS CongTy,
    COUNT(da.MaDuAn) AS SoLuongDuAn
FROM 
    CongTy ct
JOIN 
    DuAn da ON ct.MaCongTy = da.MaCongTy
GROUP BY 
    ct.MaCongTy, ct.TenCongTy
HAVING 
    COUNT(da.MaDuAn) = (
        SELECT MAX(SoLuongDuAn)
        FROM (
            SELECT COUNT(MaDuAn) AS SoLuongDuAn
            FROM DuAn
            GROUP BY MaCongTy
        ) AS DuAnCount
    );


--26. Liệt kê tên các chuyên gia có kinh nghiệm từ 5 năm trở lên và có ít nhất 4 kỹ năng khác nhau.
SELECT 
    cg.HoTen,
    cg.NamKinhNghiem,
    COUNT(DISTINCT ckn.MaKyNang) AS SoLuongKyNang
FROM 
    ChuyenGia cg
JOIN 
    ChuyenGia_KyNang ckn ON cg.MaChuyenGia = ckn.MaChuyenGia
GROUP BY 
    cg.MaChuyenGia, cg.HoTen, cg.NamKinhNghiem
HAVING 
    cg.NamKinhNghiem >= 5 AND COUNT(DISTINCT ckn.MaKyNang) >= 4;


--27. Tìm tất cả các kỹ năng mà không có chuyên gia nào sở hữu.
SELECT 
    kn.TenKyNang
FROM 
    KyNang kn
LEFT JOIN 
    ChuyenGia_KyNang ckn ON kn.MaKyNang = ckn.MaKyNang
WHERE 
    ckn.MaChuyenGia IS NULL;


--28. Hiển thị tên chuyên gia và số năm kinh nghiệm của họ, sắp xếp theo số năm kinh nghiệm giảm dần.
SELECT 
    HoTen,
    NamKinhNghiem
FROM 
    ChuyenGia
ORDER BY 
    NamKinhNghiem DESC;

--29. Tìm tất cả các cặp chuyên gia có ít nhất 2 kỹ năng giống nhau.
SELECT A.MaChuyenGia AS ChuyenGia1, B.MaChuyenGia AS ChuyenGia2
FROM ChuyenGia_KyNang A
JOIN ChuyenGia_KyNang B
    ON A.MaKyNang = B.MaKyNang
    AND A.MaChuyenGia < B.MaChuyenGia
GROUP BY A.MaChuyenGia, B.MaChuyenGia
HAVING COUNT(DISTINCT A.MaKyNang) >= 2;

--30. Tìm các công ty có ít nhất một chuyên gia nhưng không có dự án nào.
SELECT TenCongTy
FROM CongTy CT
LEFT JOIN DuAn DA
ON CT.MaCongTy = DA.MaCongTy
LEFT JOIN ChuyenGia_DuAn CD
ON DA.MaDuAn = CD.MaDuAn
WHERE DA.MaDuAn IS NULL
GROUP BY TenCongTy
HAVING COUNT(CD.MaChuyenGia) >= 1



--31. Liệt kê tên các chuyên gia cùng với số lượng kỹ năng cấp độ cao nhất mà họ sở hữu.
SELECT cg.HoTen, COUNT(cgkn.MaKyNang) AS SoLuongKyNangCaoNhat
FROM ChuyenGia cg
JOIN ChuyenGia_KyNang cgkn ON cg.MaChuyenGia = cgkn.MaChuyenGia
WHERE cgkn.CapDo = (
    SELECT MAX(CapDo)
    FROM ChuyenGia_KyNang
    WHERE MaChuyenGia = cg.MaChuyenGia
)
GROUP BY cg.MaChuyenGia, cg.HoTen;


--32. Tìm dự án mà tất cả các chuyên gia đều tham gia và hiển thị tên dự án cùng với danh sách tên chuyên gia tham gia.
SELECT da.TenDuAn, STRING_AGG(cg.HoTen, ', ') AS DanhSachChuyenGia
FROM DuAn da
JOIN ChuyenGia_DuAn cga ON da.MaDuAn = cga.MaDuAn
JOIN ChuyenGia cg ON cga.MaChuyenGia = cg.MaChuyenGia
GROUP BY da.MaDuAn, da.TenDuAn
HAVING COUNT(DISTINCT cga.MaChuyenGia) = (SELECT COUNT(*) FROM ChuyenGia);


--33. Tìm tất cả các kỹ năng mà ít nhất một chuyên gia sở hữu nhưng không thuộc về nhóm kỹ năng 'Python' hoặc 'Java'.
SELECT DISTINCT kn.TenKyNang
FROM KyNang kn
JOIN ChuyenGia_KyNang cgk ON kn.MaKyNang = cgk.MaKyNang
WHERE kn.TenKyNang NOT IN ('Python', 'Java');

   