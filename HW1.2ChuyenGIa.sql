-- 25 câu truy vấn cơ bản mới cho người mới bắt đầu, không sử dụng JOIN (51-75)

-- 51. Hiển thị tất cả thông tin của bảng ChuyenGia.
SELECT * FROM dbo.ChuyenGia


-- 52. Liệt kê họ tên và email của tất cả chuyên gia.
SELECT HoTen, Email FROM dbo.ChuyenGia 

-- 53. Hiển thị tên công ty và số nhân viên của tất cả các công ty.
SELECT TenCongTy, SoNhanVien FROM dbo.CongTy

-- 54. Liệt kê tên các dự án đang trong trạng thái 'Đang thực hiện'.
SELECT TenDuAn FROM dbo.DuAn
WHERE TrangThai = N'Đang thực hiện'


-- 55. Hiển thị tên và loại của tất cả các kỹ năng.
SELECT TenKyNang, LoaiKyNang FROM dbo.KyNang

-- 56. Liệt kê họ tên và chuyên ngành của các chuyên gia nam.
SELECT HoTen, ChuyenNganh FROM dbo.ChuyenGia
Where GioiTinh=N'Nam'


-- 57. Hiển thị tên công ty và lĩnh vực của các công ty có trên 150 nhân viên.
SELECT TenCongTy, LinhVuc FROM dbo.CongTy
WHERE SoNhanVien > 150

-- 58. Liệt kê tên các dự án bắt đầu trong năm 2023.
SELECT TenDuAn FROM dbo.DuAn
WHERE YEAR(NgayBatDau)=2023

-- 59. Hiển thị tên kỹ năng thuộc loại 'Công cụ'.
SELECT TenKyNang FROM dbo.KyNang
WHERE TenKyNang = N'Công cụ'

-- 60. Liệt kê họ tên và số năm kinh nghiệm của các chuyên gia có trên 5 năm kinh nghiệm.
SELECT HoTen, NamKinhNghiem From dbo.ChuyenGia
WHERE NamKinhNghiem > 5


-- 61. Hiển thị tên công ty và địa chỉ của các công ty trong lĩnh vực 'Phát triển phần mềm'.
SELECT TenCongTy, DiaChi FROM dbo.CongTy
WHERE LinhVuc = N'Phát triển phần mềm'

-- 62. Liệt kê tên các dự án có ngày kết thúc trong năm 2023.
SELECT TenDuAn FROM dbo.DuAn
WHERE YEAR(NgayKetThuc) = 2023


-- 63. Hiển thị tên và cấp độ của các kỹ năng trong bảng ChuyenGia_KyNang.
SELECT MaKyNang, CapDo FROM dbo.ChuyenGia_KyNang

-- 64. Liệt kê mã chuyên gia và vai trò trong các dự án từ bảng ChuyenGia_DuAn.
SELECT MaChuyenGia, VaiTro FROM dbo.ChuyenGia_DuAn

-- 65. Hiển thị họ tên và ngày sinh của các chuyên gia sinh năm 1990 trở về sau.
SELECT HoTen, NgaySinh FROM dbo.ChuyenGia
WHERE YEAR(NgaySinh) > 1990

-- 66. Liệt kê tên công ty và số nhân viên, sắp xếp theo số nhân viên giảm dần.
SELECT TenCongTy, SoNhanVien FROM dbo.CongTy
ORDER BY SoNhanVien DESC

-- 67. Hiển thị tên dự án và ngày bắt đầu, sắp xếp theo ngày bắt đầu tăng dần.
SELECT TenDuAn, NgayBatDau FROM dbo.DuAn
ORDER BY NgayBatDau ASC

-- 68. Liệt kê tên kỹ năng, chỉ hiển thị mỗi tên một lần (loại bỏ trùng lặp).
SELECT DISTINCT TenKyNang FROM dbo.KyNang

-- 69. Hiển thị họ tên và email của 5 chuyên gia đầu tiên trong danh sách.
SELECT TOP 5 HoTen, Email FROM dbo.ChuyenGia


-- 70. Liệt kê tên công ty có chứa từ 'Tech' trong tên.
SELECT TenCongTy FROM dbo.CongTY
WHERE TenCongTy LIKE '%Tech%'


-- 71. Hiển thị tên dự án và trạng thái, không bao gồm các dự án đã hoàn thành.
SELECT TenDuAn, TrangThai FROM dbo.DuAn
WHERE TrangThai <> N'Hoàn Thành'


-- 72. Liệt kê họ tên và chuyên ngành của các chuyên gia, sắp xếp theo chuyên ngành và họ tên.
SELECT HoTen, ChuyenNganh FROM dbo.ChuyenGia
ORDER BY ChuyenNganh, HoTen


-- 73. Hiển thị tên công ty và lĩnh vực, chỉ bao gồm các công ty có từ 100 đến 200 nhân viên.
SELECT TenCongTy, LinhVuc FROM dbo.CongTy
WHERE SoNhanVien BETWEEN 100 and 200

-- 74. Liệt kê tên kỹ năng và loại kỹ năng, sắp xếp theo loại kỹ năng giảm dần và tên kỹ năng tăng dần.
SELECT TenKyNang, LoaiKyNang FROM dbo.KyNang
ORDER BY LoaiKyNang DESC, TenKyNang ASC


-- 75. Hiển thị họ tên và số điện thoại của các chuyên gia có email sử dụng tên miền 'email.com'.
SELECT HoTen, SoDienThoai FROM dbo.ChuyenGia
WHERE Email LIKE '%email.com%'
