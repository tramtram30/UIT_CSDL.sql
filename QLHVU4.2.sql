
USE QLHVU
Go

--19. Khoa nào (mã khoa, tên khoa) được thành lập sớm nhất.
 SELECT MAKHOA, TENKHOA
FROM dbo.KHOA
WHERE NGTLAP = (
    SELECT MIN(NGTLAP) FROM KHOA
    );

--20. Có bao nhiêu giáo viên có học hàm là “GS” hoặc “PGS”.
SELECT COUNT(*) AS SoLuongGV
FROM dbo.GIAOVIEN
WHERE HOCHAM IN ('GS', 'PGS');

--21. Thống kê có bao nhiêu giáo viên có học vị là “CN”, “KS”, “Ths”, “TS”, “PTS” trong mỗi khoa.
SELECT KHOA.TENKHOA, GIAOVIEN.HOCVI, COUNT(*) AS SoLuongGV
FROM GIAOVIEN
JOIN KHOA ON GIAOVIEN.MAKHOA = KHOA.MAKHOA
WHERE GIAOVIEN.HOCVI IN ('CN', 'KS', 'Ths', 'TS', 'PTS')
GROUP BY KHOA.TENKHOA, GIAOVIEN.HOCVI
ORDER BY KHOA.TENKHOA, GIAOVIEN.HOCVI;

--22. Mỗi môn học thống kê số lượng học viên theo kết quả (đạt và không đạt).
SELECT KQT.MAMH, KQT.KQUA, COUNT(KQT.MAHV) AS SOHV
FROM dbo.KETQUATHI AS KQT
WHERE 
    LANTHI = (
        SELECT MAX(LANTHI)
        FROM dbo.KETQUATHI
        WHERE 
            KETQUATHI.MAHV = KQT.MAHV
            AND KETQUATHI.MAMH = KQT.MAMH
    )
GROUP BY KQT.MAMH, KQT.KQUA;

--23. Tìm giáo viên (mã giáo viên, họ tên) là giáo viên chủ nhiệm của một lớp, đồng thời dạy cho lớp đó ít nhất một môn học.
SELECT DISTINCT GV.MAGV, GV.HOTEN
FROM dbo.GIAOVIEN GV
JOIN dbo.LOP AS L ON GV.MAGV = L.MAGVCN
WHERE EXISTS(
    SELECT *
    FROM dbo.GIANGDAY AS GD
    WHERE GD.MAGV = GV.MAGV
    AND GD.MALOP = L.MALOP
)

--24. Tìm họ tên lớp trưởng của lớp có sỉ số cao nhất.
SELECT HV.HO, HV.TEN
FROM dbo.HOCVIEN AS HV
JOIN dbo.LOP AS L ON HV.MALOP = L.MALOP
WHERE L.SISO = (
    SELECT MAX(SISO)
    FROM dbo.LOP
)
AND HV.MAHV = L.TRGLOP

--25. * Tìm họ tên những LOPTRG thi không đạt quá 3 môn (mỗi môn đều thi không đạt ở tất cả các lần thi).
SELECT HV.HO, HV.TEN
FROM dbo.HOCVIEN AS HV
JOIN dbo.LOP AS L ON HV.MAHV = L.TRGLOP
JOIN dbo.KETQUATHI AS KQ ON KQ.MAHV = HV.MAHV
WHERE KQ.KQUA = 'Khong dat'
  AND KQ.LANTHI = (
    SELECT MAX(LANTHI)
    FROM dbo.KETQUATHI
    WHERE KETQUATHI.MAHV = KQ.MAHV
      AND KETQUATHI.MAMH = KQ.MAMH
    GROUP BY KETQUATHI.MAMH
  )
GROUP BY HV.HO, HV.TEN, HV.MAHV
HAVING COUNT(DISTINCT KQ.MAMH) <= 3

--26. Tìm học viên (mã học viên, họ tên) có số môn đạt điểm 9, 10 nhiều nhất.
SELECT TOP 1 HV.MAHV, HV.HO, HV.TEN
FROM dbo.HOCVIEN AS HV
JOIN dbo.KETQUATHI AS KQ ON HV.MAHV = KQ.MAHV
WHERE KQ.DIEM >= 9
GROUP BY HV.MAHV, HV.HO, HV.TEN
ORDER BY COUNT(KQ.MAMH) DESC

--27. Trong từng lớp, tìm học viên (mã học viên, họ tên) có số môn đạt điểm 9, 10 nhiều nhất.
WITH XEPHANG AS(
	SELECT MALOP, HV.MAHV, HO+' '+ TEN AS HOTEN,
	RANK() OVER (PARTITION BY MALOP ORDER BY COUNT(KQ.MAMH) DESC) AS XH
	FROM dbo.HOCVIEN AS HV
	JOIN dbo.KETQUATHI AS KQ ON HV.MAHV = KQ.MAHV
	WHERE DIEM >= 9
	GROUP BY MALOP, HV.MAHV, HO, TEN
)
SELECT MALOP, MAHV, HOTEN
FROM XEPHANG
WHERE XEPHANG.XH = 1

--28. Trong từng học kỳ của từng năm, mỗi giáo viên phân công dạy bao nhiêu môn học, bao nhiêu lớp.
SELECT HOCKY, MAGV, 
    COUNT(DISTINCT MAMH) AS SOMONHOCGD,  
    COUNT(DISTINCT MALOP) AS SOLOPGD     
FROM dbo.GIANGDAY
GROUP BY HOCKY, MAGV
ORDER BY HOCKY ASC;

--29. Trong từng học kỳ của từng năm, tìm giáo viên (mã giáo viên, họ tên) giảng dạy nhiều nhất.
WITH XEPHANGGV AS (
    SELECT HOCKY, NAM, MAGV,
           COUNT(DISTINCT MAMH) AS SOMONHOC,  
           RANK() OVER (PARTITION BY HOCKY, NAM ORDER BY COUNT(DISTINCT MAMH) DESC) AS XEPHANG  -- Sắp xếp giảm dần
    FROM dbo.GIANGDAY
    GROUP BY HOCKY, NAM, MAGV
)
SELECT HOCKY, NAM, MAGV
FROM XEPHANGGV
WHERE XEPHANG = 1  
ORDER BY HOCKY, NAM;

--30. Tìm môn học (mã môn học, tên môn học) có nhiều học viên thi không đạt (ở lần thi thứ 1) nhất.
SELECT TOP 1 WITH TIES KQ.MAMH, MH.TENMH
FROM dbo.MONHOC AS MH
JOIN dbo.KETQUATHI AS KQ ON MH.MAMH = KQ.MAMH
WHERE KQ.KQUA = 'Khong Dat' AND KQ.LANTHI = 1
GROUP BY KQ.MAMH, MH.TENMH
ORDER BY COUNT(DISTINCT KQ.MAHV) DESC;

--31. Tìm học viên (mã học viên, họ tên) thi môn nào cũng đạt (chỉ xét lần thi thứ 1).
SELECT HV.MAHV, HV.HO + ' ' + HV.TEN AS HOTEN
FROM dbo.HOCVIEN AS HV
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.KETQUATHI AS KQ
    WHERE KQ.MAHV = HV.MAHV
    AND KQ.LANTHI = 1
    AND KQ.KQUA = 'Khong Dat'
)


--32. * Tìm học viên (mã học viên, họ tên) thi môn nào cũng đạt (chỉ xét lần thi sau cùng).
SELECT HV.MAHV, HV.HO + ' ' + HV.TEN AS HOTEN
FROM dbo.HOCVIEN AS HV
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.KETQUATHI AS KQ
    WHERE KQ.MAHV = HV.MAHV
    AND KQ.LANTHI = (SELECT MAX(LANTHI) FROM dbo.KETQUATHI WHERE MAHV = HV.MAHV)
    AND KQ.KQUA = 'Khong Dat'
)

--33. * Tìm học viên (mã học viên, họ tên) đã thi tất cả các môn và đều đạt (chỉ xét lần thi thứ 1).
SELECT HV.MAHV, HV.HO + ' ' + HV.TEN AS HOTEN
FROM dbo.HOCVIEN AS HV
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.MONHOC AS MH
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.KETQUATHI AS KQ
        WHERE KQ.MAHV = HV.MAHV
        AND KQ.MAMH = MH.MAMH
        AND KQ.LANTHI = 1
        AND KQ.KQUA = 'Dat'
    )
)

--34. * Tìm học viên (mã học viên, họ tên) đã thi tất cả các môn và đều đạt (chỉ xét lần thi sau cùng).
SELECT HV.MAHV, HV.HO + ' ' + HV.TEN AS HOTEN
FROM dbo.HOCVIEN AS HV
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.MONHOC AS MH
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.KETQUATHI AS KQ
        WHERE KQ.MAHV = HV.MAHV
        AND KQ.MAMH = MH.MAMH
        AND KQ.LANTHI = (SELECT MAX(LANTHI)
                         FROM dbo.KETQUATHI
                         WHERE MAHV = HV.MAHV AND MAMH = MH.MAMH)
        AND KQ.KQUA = 'Dat'
    )
)

--35. ** Tìm học viên (mã học viên, họ tên) có điểm thi cao nhất trong từng môn (lấy điểm ở lần thi sau cùng).
WITH XEPHANGHOCVIEN AS( 
    SELECT KQ.MAMH, HV.MAHV, HO + ' ' + TEN AS HOTEN,
    RANK() OVER (PARTITION BY KQ.MAMH ORDER BY DIEM DESC) AS XEPHANG
    FROM dbo.HOCVIEN AS HV
    JOIN dbo.KETQUATHI AS KQ ON HV.MAHV = KQ.MAHV
    WHERE KQ.LANTHI = (
        SELECT MAX(LANTHI)
        FROM dbo.KETQUATHI
        WHERE KETQUATHI.MAHV = KQ.MAHV AND KETQUATHI.MAMH = KQ.MAMH
    )
)
SELECT MAMH, MAHV, HOTEN
FROM XEPHANGHOCVIEN
WHERE XEPHANG = 1;
