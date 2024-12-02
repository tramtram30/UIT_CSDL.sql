--19. Có bao nhiêu hóa đơn không phải của khách hàng đăng ký thành viên mua?
SELECT COUNT(*) 
FROM HOADON
WHERE MAKH IS NULL;

--20. Có bao nhiêu sản phẩm khác nhau được bán ra trong năm 2006.
SELECT COUNT(DISTINCT MASP)
FROM CTHD
JOIN HOADON ON CTHD.SOHD = HOADON.SOHD
WHERE YEAR(NGHD) = 2006;

--21. Cho biết trị giá hóa đơn cao nhất, thấp nhất là bao nhiêu?
SELECT MAX(TRIGIA) AS TRIGIACAONHAT, MIN(TRIGIA) AS TRIGIATHAPNHAT
FROM HOADON;

--22. Trị giá trung bình của tất cả các hóa đơn được bán ra trong năm 2006 là bao nhiêu?
SELECT AVG(TRIGIA) AS TRIGIATB2006
FROM HOADON
WHERE YEAR(NGHD) = 2006;

--23. Tính doanh thu bán hàng trong năm 2006.
SELECT SUM(TRIGIA) AS DOANHTHU2006
FROM HOADON
WHERE YEAR(NGHD) = 2006;

--24. Tìm số hóa đơn có trị giá cao nhất trong năm 2006.
SELECT TOP 1 SOHD, TRIGIA
FROM HOADON
WHERE YEAR(NGHD) = 2006
ORDER BY TRIGIA DESC;

--25. Tìm họ tên khách hàng đã mua hóa đơn có trị giá cao nhất trong năm 2006.
SELECT TOP 1 KHACHHANG.HOTEN
FROM HOADON
JOIN KHACHHANG ON HOADON.MAKH = KHACHHANG.MAKH
WHERE YEAR(HOADON.NGHD) = 2006
ORDER BY HOADON.TRIGIA DESC;

--26. In ra danh sách 3 khách hàng (MAKH, HOTEN) có doanh số cao nhất.
SELECT TOP 3 KHACHHANG.MAKH, KHACHHANG.HOTEN
FROM KHACHHANG
ORDER BY KHACHHANG.DOANHSO DESC;

--27. In ra danh sách các sản phẩm (MASP, TENSP) có giá bán bằng 1 trong 3 mức giá cao nhất.
SELECT MASP, TENSP
FROM dbo.SANPHAM
WHERE GIA IN (
	SELECT TOP 3 GIA
	FROM dbo.SANPHAM
	ORDER BY GIA DESC
)

--28. In ra danh sách các sản phẩm (MASP, TENSP) do “Thai Lan” sản xuất có giá bằng 1 trong 3 mức giá cao nhất (của tất cả các sản phẩm).
SELECT MASP, TENSP
FROM dbo.SANPHAM
WHERE NUOCSX = 'Thai Lan'
	AND GIA IN (
	SELECT TOP 3 GIA
	FROM dbo.SANPHAM
	ORDER BY GIA DESC
)

--29. In ra danh sách các sản phẩm (MASP, TENSP) do “Trung Quoc” sản xuất có giá bằng 1 trong 3 mức giá cao nhất (của sản phẩm do “Trung Quoc” sản xuất).
SELECT MASP, TENSP
FROM dbo.SANPHAM
WHERE NUOCSX = 'Trung Quoc'
	AND GIA IN (
	SELECT TOP 3 GIA
	FROM dbo.SANPHAM
	WHERE NUOCSX = 'Trung Quoc'
	ORDER BY GIA DESC
)

--30. * In ra danh sách 3 khách hàng có doanh số cao nhất (sắp xếp theo kiểu xếp hạng).
WITH DoanhSoKhachHang AS (
    SELECT KH.MAKH, KH.HOTEN, SUM(HD.TRIGIA) AS DOANHSO
    FROM dbo.KHACHHANG KH
    JOIN dbo.HOADON HD ON KH.MAKH = HD.MAKH
    WHERE YEAR(HD.NGHD) = 2006
    GROUP BY KH.MAKH, KH.HOTEN
)
SELECT MAKH, HOTEN, ThuHangDoanhSo
FROM (
    SELECT MAKH, HOTEN, DOANHSO,
           DENSE_RANK() OVER (ORDER BY DOANHSO DESC) AS ThuHangDoanhSo
    FROM DoanhSoKhachHang
) AS RankedCustomers
WHERE ThuHangDoanhSo <= 3
ORDER BY ThuHangDoanhSo;


--31. Tính tổng số sản phẩm do “Trung Quoc” sản xuất.
SELECT COUNT(*) AS TongSoSanPham
FROM dbo.SANPHAM
WHERE NUOCSX = 'Trung Quoc';

--32. Tính tổng số sản phẩm của từng nước sản xuất.
SELECT NUOCSX, COUNT(*) AS TongSoSanPham
FROM dbo.SANPHAM
GROUP BY NUOCSX;

--33. Với từng nước sản xuất, tìm giá bán cao nhất, thấp nhất, trung bình của các sản phẩm.
SELECT 
    NUOCSX,
    MAX(GIA) AS MAXGIA,
    MIN(GIA) AS MINGIA,
    AVG(GIA) AS AVGGIA
FROM dbo.SANPHAM
GROUP BY NUOCSX;

--34. Tính doanh thu bán hàng mỗi ngày.
SELECT NGHD, SUM(TRIGIA) AS DoanhThuMoiNgay
FROM dbo.HOADON
GROUP BY NGHD
ORDER BY NGHD;

--35. Tính tổng số lượng của từng sản phẩm bán ra trong tháng 10/2006.
SELECT MASP, SUM(CTHD.SL) AS SOLUONG
FROM dbo.HOADON AS HD
JOIN dbo.CTHD ON HD.SOHD = CTHD.SOHD
WHERE MONTH(HD.NGHD) = 10 AND YEAR(HD.NGHD) = 2006
GROUP BY MASP

--36. Tính doanh thu bán hàng của từng tháng trong năm 2006.
SELECT MONTH(NGHD) AS THANG, SUM(TRIGIA) AS DOANHTHU
FROM dbo.HOADON
WHERE YEAR(NGHD) = 2006
GROUP BY MONTH(NGHD)

--37. Tìm hóa đơn có mua ít nhất 4 sản phẩm khác nhau.
SELECT SOHD
FROM dbo.CTHD
GROUP BY SOHD
HAVING COUNT(DISTINCT MASP) >= 4;

--38. Tìm hóa đơn có mua 3 sản phẩm do “Viet Nam” sản xuất (3 sản phẩm khác nhau).
SELECT CTHD.SOHD
FROM dbo.SANPHAM AS SP
JOIN dbo.CTHD ON CTHD.MASP = SP.MASP
WHERE SP.NUOCSX = 'Viet Nam'
GROUP BY CTHD.SOHD
HAVING COUNT(DISTINCT CTHD.MASP) >= 3

--39. Tìm khách hàng (MAKH, HOTEN) có số lần mua hàng nhiều nhất.
SELECT KH.MAKH, HOTEN
FROM dbo.KHACHHANG AS KH
JOIN dbo.HOADON AS HD ON KH.MAKH = HD.MAKH
GROUP BY KH.MAKH, HOTEN
HAVING COUNT(HD.MAKH) >= ALL(
	SELECT COUNT(HOADON.MAKH)
	FROM dbo.HOADON
	GROUP BY HOADON.MAKH
)

--40. Tháng mấy trong năm 2006, doanh số bán hàng cao nhất ?
SELECT TOP 1 
    MONTH(NGHD) AS Thang, 
    SUM(TRIGIA) AS DoanhSo
FROM dbo.HOADON
WHERE YEAR(NGHD) = 2006
GROUP BY MONTH(NGHD)
ORDER BY DoanhSo DESC;

--41. Tìm sản phẩm (MASP, TENSP) có tổng số lượng bán ra thấp nhất trong năm 2006.
SELECT TOP 1 SP.MASP, TENSP
FROM dbo.SANPHAM AS SP
JOIN dbo.CTHD ON SP.MASP = CTHD.MASP
JOIN dbo.HOADON AS HD ON HD.SOHD = CTHD.SOHD
WHERE YEAR(NGHD) = 2006
GROUP BY SP.MASP, TENSP
ORDER BY SUM(SL) ASC

--42. *Mỗi nước sản xuất, tìm sản phẩm (MASP,TENSP) có giá bán cao nhất.
SELECT NUOCSX, MASP, TENSP
FROM dbo.SANPHAM AS SP1
WHERE EXISTS (
	SELECT NUOCSX
	FROM dbo.SANPHAM AS SP2
	GROUP BY NUOCSX
	HAVING SP1.NUOCSX = SP2.NUOCSX
		AND SP1.GIA = MAX(SP2.GIA)
)

--43. Tìm nước sản xuất sản xuất ít nhất 3 sản phẩm có giá bán khác nhau.
SELECT NUOCSX
FROM dbo.SANPHAM
GROUP BY NUOCSX
HAVING COUNT(DISTINCT GIA) >= 3;

--44. *Trong 10 khách hàng có doanh số cao nhất, tìm khách hàng có số lần mua hàng nhiều nhất.
WITH Top10 AS (
    SELECT TOP 10 HD.MAKH, KH.HOTEN, SUM(HD.TRIGIA) AS TotalSales
    FROM dbo.HOADON HD
    JOIN dbo.KHACHHANG KH ON HD.MAKH = KH.MAKH
    GROUP BY HD.MAKH, KH.HOTEN
    ORDER BY TotalSales DESC
)
SELECT TOP 1 k.HOTEN, COUNT(*) AS NumberOfPurchases
FROM dbo.HOADON h
JOIN dbo.KHACHHANG k ON h.MAKH = k.MAKH
WHERE h.MAKH IN (SELECT MAKH FROM Top10)
GROUP BY h.MAKH, k.HOTEN
ORDER BY NumberOfPurchases DESC;
