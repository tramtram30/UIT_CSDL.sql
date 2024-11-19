--1. Tìm danh sách các giáo viên có mức lương cao nhất trong mỗi khoa, kèm theo tên khoa và hệ số lương.
SELECT k.TENKHOA, gv.HOTEN, gv.MAGV, gv.MUCLUONG, gv.HESO
FROM KHOA k
JOIN GIAOVIEN gv ON k.MAKHOA = gv.MAKHOA
WHERE gv.MUCLUONG = (
    SELECT MAX(gv2.MUCLUONG)
    FROM GIAOVIEN gv2
    WHERE gv2.MAKHOA = k.MAKHOA
)
ORDER BY k.TENKHOA;

--2. Liệt kê danh sách các học viên có điểm trung bình cao nhất trong mỗi lớp, kèm theo tên lớp và mã lớp.
WITH DIEMTBSV AS (
SELECT L.MALOP, TENLOP, HO+' '+TEN AS HOTEN, DIEMTB
FROM dbo.HOCVIEN AS HV
JOIN dbo.LOP AS L ON L.MALOP = HV.MALOP
GROUP BY L.MALOP, TENLOP, HO, TEN, DIEMTB
),

DIEMTBMAX AS (
	SELECT MALOP, MAX(DI) AS MAXDIEMTB
	FROM HOCVIEN
	GROUP BY MALOP
)

SELECT *
FROM DIEMTBSV AS A 
JOIN DIEMTBMAX AS B ON A.MALOP = B.MALOP AND A.DIEMTB = B.MAXDIEMTB



--3. Tính tổng số tiết lý thuyết (TCLT) và thực hành (TCTH) mà mỗi giáo viên đã giảng dạy trong năm học 2023, sắp xếp theo tổng số tiết từ cao xuống thấp.
SELECT MAGV, SUM(TCLT) AS TONGTCLT, SUM(TCTH) AS TONGTCTH
FROM dbo.GIANGDAY AS GD 
JOIN dbo.MONHOC AS MH ON GD.MAMH = MH.MAMH
GROUP BY MAGV
ORDER BY COUNT(GD.MAMH) DESC


--4. Tìm những học viên thi cùng một môn học nhiều hơn 2 lần nhưng chưa bao giờ đạt điểm trên 7, kèm theo mã học viên và mã môn học.
SELECT kq.MAHV, kq.MAMH
FROM KETQUATHI kq
GROUP BY kq.MAHV, kq.MAMH
HAVING COUNT(kq.LANTHI) > 2
   AND MAX(kq.DIEM) <= 7;

--5. Xác định những giáo viên đã giảng dạy ít nhất 3 môn học khác nhau trong cùng một năm học, kèm theo năm học và số lượng môn giảng dạy.
SELECT gd.MAGV, gd.NAM, COUNT(DISTINCT gd.MAMH) AS SO_MON_GIANGDAY
FROM GIANGDAY gd
GROUP BY gd.MAGV, gd.NAM
HAVING COUNT(DISTINCT gd.MAMH) >= 3;

--6. Tìm những học viên có sinh nhật trùng với ngày thành lập của khoa mà họ đang theo học, kèm theo tên khoa và ngày sinh của học viên.
SELECT hv.HO, hv.TEN, hv.NGSINH, k.TENKHOA, k.NGTLAP
FROM HOCVIEN hv
JOIN KHOA k ON hv.MALOP = k.MAKHOA
WHERE CONVERT(DATE, hv.NGSINH) = CONVERT(DATE, k.NGTLAP)
ORDER BY hv.HO, hv.TEN;


--7. Liệt kê các môn học không có điều kiện tiên quyết (không yêu cầu môn học trước), kèm theo mã môn và tên môn học.
SELECT mh.MAMH, mh.TENMH
FROM MONHOC mh
LEFT JOIN DIEUKIEN dk ON mh.MAMH = dk.MAMH
WHERE dk.MAMH_TRUOC IS NULL;

--8. Tìm danh sách các giáo viên dạy nhiều môn học nhất trong học kỳ 1 năm 2006, kèm theo số lượng môn học mà họ đã dạy.
SELECT gv.HOTEN, gv.MAGV, COUNT(gd.MAMH) AS SO_LUONG_MON
FROM GIANGDAY gd
JOIN GIAOVIEN gv ON gd.MAGV = gv.MAGV
WHERE gd.HOCKY = 1 AND gd.NAM = 2006
GROUP BY gv.HOTEN, gv.MAGV
ORDER BY SO_LUONG_MON DESC;


--9. Tìm những giáo viên đã dạy cả môn “Co So Du Lieu” và “Cau Truc Roi Rac” trong cùng một học kỳ, kèm theo học kỳ và năm học.
SELECT gd.MAGV, gv.HOTEN, gd.HOCKY, gd.NAM
FROM GIANGDAY gd
JOIN GIAOVIEN gv ON gd.MAGV = gv.MAGV
JOIN MONHOC mh1 ON gd.MAMH = mh1.MAMH
WHERE (mh1.TENMH = 'CSDL' OR mh1.TENMH = 'CTRR')
GROUP BY gd.MAGV, gv.HOTEN, gd.HOCKY, gd.NAM
HAVING COUNT(DISTINCT mh1.TENMH) = 2;

-- 10. Liệt kê danh sách các môn học mà tất cả các giáo viên trong khoa “CNTT” đều đã giảng dạy ít nhất một lần trong năm 2006. 
SELECT DISTINCT GD.MAMH
FROM GIANGDAY GD
WHERE GD.NAM = 2006
AND GD.MAGV IN (
    SELECT GV.MAGV
    FROM GIAOVIEN GV
    WHERE GV.MAKHOA = 'CNTT'
)
GROUP BY GD.MAMH
HAVING COUNT(DISTINCT GD.MAGV) = (
    SELECT COUNT(GV.MAGV)
    FROM GIAOVIEN GV
    WHERE GV.MAKHOA = 'CNTT'
)

-- 11. Tìm những giáo viên có hệ số lương cao hơn mức lương trung bình của tất cả giáo viên trong khoa của họ, kèm theo tên khoa và hệ số lương của giáo viên đó.
SELECT 
    GV.HOTEN AS TenGiaoVien,
    K.TENKHOA AS TenKhoa,
    GV.HESO AS HeSoLuong
FROM GIAOVIEN GV
JOIN KHOA K ON GV.MAKHOA = K.MAKHOA
WHERE GV.HESO > (
    SELECT AVG(GV1.HESO)
    FROM GIAOVIEN GV1
    WHERE GV1.MAKHOA = GV.MAKHOA
)

-- 12. Xác định những lớp có sĩ số lớn hơn 40 nhưng không có giáo viên nào dạy quá 2 môn trong học kỳ 1 năm 2006, kèm theo tên lớp và sĩ số.
SELECT L.TENLOP, L.SISO
FROM LOP L
WHERE L.SISO > 40
  AND L.MALOP NOT IN (
    SELECT GD.MALOP
    FROM GIANGDAY GD
    WHERE GD.HOCKY = 1 AND GD.NAM = 2006
    GROUP BY GD.MALOP, GD.MAGV
    HAVING COUNT(GD.MAMH) > 2
)

-- 13. Tìm những môn học mà tất cả các học viên của lớp “K11” đều đạt điểm trên 7 trong lần thi cuối cùng của họ, kèm theo mã môn và tên môn học.
SELECT MH.MAMH, MH.TENMH
FROM MONHOC MH
WHERE MH.MAMH IN (
    SELECT KQ.MAMH
    FROM KETQUATHI KQ
    JOIN HOCVIEN HV ON KQ.MAHV = HV.MAHV
    WHERE HV.MALOP = 'K11'
      AND KQ.LANTHI = (
          SELECT MAX(LANTHI)
          FROM KETQUATHI KQ2
          WHERE KQ2.MAHV = KQ.MAHV AND KQ2.MAMH = KQ.MAMH
      )
    GROUP BY KQ.MAMH
    HAVING MIN(KQ.DIEM) > 7
)

-- 14. Liệt kê danh sách các giáo viên đã dạy ít nhất một môn học trong mỗi học kỳ của năm 2006, kèm theo mã giáo viên và số lượng học kỳ mà họ đã giảng dạy. 
SELECT GD.MAGV, COUNT(DISTINCT GD.HOCKY) AS SoHocKy
FROM GIANGDAY GD
WHERE GD.NAM = 2006
GROUP BY GD.MAGV
HAVING COUNT(DISTINCT GD.HOCKY) = (
    SELECT COUNT(DISTINCT GD2.HOCKY)
    FROM GIANGDAY GD2
    WHERE GD2.NAM = 2006
)
 
 -- 15. Tìm những giáo viên vừa là trưởng khoa vừa giảng dạy ít nhất 2 môn khác nhau trong năm 2006, kèm theo tên khoa và mã giáo viên. 
SELECT GV.MAGV, GV.HOTEN, K.TENKHOA
FROM GIAOVIEN GV
JOIN KHOA K
ON GV.MAGV = K.TRGKHOA
JOIN GIANGDAY GD
ON GV.MAGV = GD.MAGV
WHERE GD.NAM = 2006
GROUP BY GV.MAGV, GV.HOTEN, K.TENKHOA
HAVING COUNT(DISTINCT GD.MAMH) >= 2

-- 16. Xác định những môn học mà tất cả các lớp do giáo viên chủ nhiệm “Nguyen To Lan” đều phải học trong năm 2006, kèm theo mã lớp và tên lớp.
SELECT GD.MAMH, MH.TENMH, GD.MALOP, L.TENLOP
FROM GIANGDAY GD
JOIN MONHOC MH
ON GD.MAMH = MH.MAMH
JOIN LOP L
ON GD.MALOP = L.MALOP
WHERE L.MALOP IN (
    SELECT MALOP
    FROM LOP
    WHERE TRGLOP = (
        SELECT MAGV
        FROM GIAOVIEN
        WHERE HOTEN = 'Nguyen To Lan'
    )
)
AND GD.NAM = 2006
GROUP BY GD.MAMH, MH.TENMH, GD.MALOP, L.TENLOP
HAVING COUNT(DISTINCT GD.MALOP) = (
    SELECT COUNT(MALOP)
    FROM LOP
    WHERE TRGLOP = (
        SELECT MAGV
        FROM GIAOVIEN
        WHERE HOTEN = 'Nguyen To Lan'
    )
)

-- 17. Liệt kê danh sách các môn học mà không có điều kiện tiên quyết (không cần phải học trước bất kỳ môn nào), nhưng lại là điều kiện tiên quyết cho ít nhất 2 môn khác nhau, kèm theo mã môn và tên môn học.
SELECT MH.MAMH, MH.TENMH
FROM MONHOC MH
WHERE MH.MAMH NOT IN (
    SELECT MAMH
    FROM DIEUKIEN
)
AND MH.MAMH IN (
    SELECT MAMH_TRUOC
    FROM DIEUKIEN
    GROUP BY MAMH_TRUOC
    HAVING COUNT(MAMH) >= 2
)

-- 18. Tìm những học viên (mã học viên, họ tên) thi không đạt môn CSDL ở lần thi thứ 1 nhưng chưa thi lại môn này và cũng chưa thi bất kỳ môn nào khác sau lần đó. 
SELECT HV.MAHV, HV.HO, HV.TEN
FROM HOCVIEN HV
JOIN KETQUATHI KQ1 ON HV.MAHV = KQ1.MAHV
WHERE KQ1.MAMH = 'CSDL' 
  AND KQ1.LANTHI = 1
  AND KQ1.DIEM < 5
  AND NOT EXISTS (
      SELECT 1
      FROM KETQUATHI KQ2
      WHERE KQ2.MAHV = KQ1.MAHV
        AND KQ2.MAMH = 'CSDL'
        AND KQ2.LANTHI > 1
  )
  AND NOT EXISTS (
      SELECT 1
      FROM KETQUATHI KQ3
      WHERE KQ3.MAHV = KQ1.MAHV
        AND KQ3.NGTHI > KQ1.NGTHI
  )

-- 19. Tìm những học viên (mã học viên, họ tên) thi không đạt môn CSDL ở lần thi thứ 1 nhưng chưa thi lại môn này và cũng chưa thi bất kỳ môn nào khác sau lần đó. 

SELECT HV.MAHV, HV.HO, HV.TEN
FROM HOCVIEN HV
JOIN KETQUATHI KQ1 ON HV.MAHV = KQ1.MAHV
WHERE KQ1.MAMH = 'CSDL' 
  AND KQ1.LANTHI = 1
  AND KQ1.DIEM < 5
  AND NOT EXISTS (
      SELECT 1
      FROM KETQUATHI KQ2
      WHERE KQ2.MAHV = KQ1.MAHV
        AND KQ2.MAMH = 'CSDL'
        AND KQ2.LANTHI > 1
  )
  AND NOT EXISTS (
      SELECT 1
      FROM KETQUATHI KQ3
      WHERE KQ3.MAHV = KQ1.MAHV
        AND KQ3.NGTHI > KQ1.NGTHI
  )

-- 20. Tìm giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học nào thuộc khoa giáo viên đó phụ trách trong năm 2006, nhưng đã từng giảng dạy các môn khác của khoa khác.
SELECT GV.MAGV, GV.HOTEN
FROM GIAOVIEN GV
WHERE GV.MAGV IN (
    SELECT DISTINCT GD.MAGV
    FROM GIANGDAY GD
    JOIN MONHOC MH ON GD.MAMH = MH.MAMH
    WHERE GD.NAM = 2006
    AND MH.MAKHOA != GV.MAKHOA
)
AND GV.MAGV IN (
    SELECT DISTINCT GD.MAGV
    FROM GIANGDAY GD
    JOIN MONHOC MH ON GD.MAMH = MH.MAMH
    WHERE GD.NAM < 2006
    AND MH.MAKHOA != GV.MAKHOA
)

-- 21. Tìm họ tên các học viên thuộc lớp “K11” thi một môn bất kỳ quá 3 lần vẫn "Khong dat", nhưng có điểm trung bình tất cả các môn khác trên 7.
SELECT HV.HO + ' ' + HV.TEN AS HoTen
FROM HOCVIEN HV
WHERE HV.MALOP = 'K11'
AND HV.MAHV IN (
    -- Lọc học viên đã thi một môn quá 3 lần và không đạt
    SELECT KT.MAHV
    FROM KETQUATHI KT
    WHERE KT.LANTHI > 3 AND KT.KQUA = 'Khong dat'
    GROUP BY KT.MAHV, KT.MAMH
)
AND HV.MAHV IN (
    -- Lọc học viên có điểm trung bình của các môn còn lại > 7
    SELECT KT.MAHV
    FROM KETQUATHI KT
    JOIN MONHOC MH ON KT.MAMH = MH.MAMH
    WHERE KT.KQUA != 'Khong dat'
    GROUP BY KT.MAHV
    HAVING AVG(KT.DIEM) > 7
)

-- 22. Tìm họ tên các học viên thuộc lớp “K11” thi một môn bất kỳ quá 3 lần vẫn "Khong dat" và thi lần thứ 2 của môn CTRR đạt đúng 5 điểm, nhưng điểm trung bình của tất cả các môn khác đều dưới 6. 
SELECT HV.HO + ' ' + HV.TEN AS HoTen
FROM HOCVIEN HV
WHERE HV.MALOP = 'K11'
AND HV.MAHV IN (
    -- Lọc học viên thi một môn quá 3 lần và không đạt
    SELECT KT.MAHV
    FROM KETQUATHI KT
    WHERE KT.LANTHI > 3 AND KT.KQUA = 'Khong dat'
    GROUP BY KT.MAHV, KT.MAMH
)
AND HV.MAHV IN (
    -- Lọc học viên thi môn CTRR lần thứ 2 đạt đúng 5 điểm
    SELECT KT.MAHV
    FROM KETQUATHI KT
    WHERE KT.MAMH = 'CTRR' AND KT.LANTHI = 2 AND KT.DIEM = 5
)
AND HV.MAHV IN (
    -- Lọc học viên có điểm trung bình của tất cả các môn khác < 6
    SELECT KT.MAHV
    FROM KETQUATHI KT
    WHERE KT.MAMH != 'CTRR' -- Bỏ qua môn CTRR
    GROUP BY KT.MAHV
    HAVING AVG(KT.DIEM) < 6
)

-- 23. Tìm họ tên giáo viên dạy môn CTRR cho ít nhất hai lớp trong cùng một học kỳ của một năm học và có tổng số tiết giảng dạy (TCLT + TCTH) lớn hơn 30 tiết.
SELECT GV.HOTEN, GD.HOCKY, GD.NAM, COUNT(DISTINCT GD.MALOP) AS SoLop, 
       SUM(MH.TCLT + MH.TCTH) AS TongTiet
FROM GIANGDAY GD
JOIN GIAOVIEN GV
    ON GD.MAGV = GV.MAGV
JOIN MONHOC MH
    ON GD.MAMH = MH.MAMH
WHERE MH.TENMH = 'CTRR'
GROUP BY GV.HOTEN, GD.HOCKY, GD.NAM
HAVING COUNT(DISTINCT GD.MALOP) >= 2
   AND SUM(MH.TCLT + MH.TCTH) > 30

-- 24. Danh sách học viên và điểm thi môn CSDL (chỉ lấy điểm của lần thi sau cùng), kèm theo số lần thi của mỗi học viên cho môn này
SELECT HV.MAHV, HV.HO + ' ' + HV.TEN AS HoTen, KQ.DIEM AS DiemLanCuoi, 
       COUNT(KQ.LANTHI) AS SoLanThi
FROM HOCVIEN HV
JOIN KETQUATHI KQ
    ON HV.MAHV = KQ.MAHV
WHERE KQ.MAMH = 'CSDL'
  AND KQ.LANTHI = (
      SELECT MAX(KT.LANTHI)
      FROM KETQUATHI KT
      WHERE KT.MAHV = KQ.MAHV
        AND KT.MAMH = KQ.MAMH
  )
GROUP BY HV.MAHV, HV.HO, HV.TEN, KQ.DIEM;

--25. Danh sách học viên và điểm trung bình tất cả các môn (chỉ lấy điểm của lần thi sau cùng), kèm theo số lần thi trung bình cho tất cả các môn mà mỗi học viên đã tham gia.
WITH LanThiCuoiCuaMon AS (
    SELECT MAHV, MAMH, MAX(LANTHI) AS LanThiCuoi
    FROM KETQUATHI
    GROUP BY MAHV, MAMH
),
DiemThiLanCuoi AS (
    SELECT KT.MAHV, KT.MAMH, KT.DIEM, KT.LANTHI
    FROM KETQUATHI KT
    JOIN LanThiCuoiCuaMon LTC
        ON KT.MAHV = LTC.MAHV
       AND KT.MAMH = LTC.MAMH
       AND KT.LANTHI = LTC.LanThiCuoi
),
SoLanThiCuaTungMon AS (
    SELECT MAHV, MAMH, COUNT(LANTHI) AS SoLanThi
    FROM KETQUATHI
    GROUP BY MAHV, MAMH
)
SELECT HV.MAHV, HV.HO + ' ' + HV.TEN AS HoTen,
       AVG(DLC.DIEM) AS DiemTrungBinh,
       AVG(SLT.SoLanThi) AS SoLanThiTrungBinh
FROM HOCVIEN HV
LEFT JOIN DiemThiLanCuoi DLC
    ON HV.MAHV = DLC.MAHV
LEFT JOIN SoLanThiCuaTungMon SLT
    ON HV.MAHV = SLT.MAHV AND DLC.MAMH = SLT.MAMH
GROUP BY HV.MAHV, HV.HO, HV.TEN
