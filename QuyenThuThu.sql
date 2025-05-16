
USE HQTCSDL_QLTV;
GO

-- PHẦN 0: DỌN DẸP DỮ LIỆU DEMO
-- Quyền: DELETE, UPDATE, SELECT trên các bảng PHIEUMUONTRA, CO, DANGKY, SACH, TACGIA, THELOAI
PRINT N'--- 0. DỌN DẸP DỮ LIỆU DEMO ---';
IF EXISTS (SELECT 1 FROM dbo.PHIEUMUONTRA WHERE MaPhieu IN (N'PMT999', N'PMT998'))
BEGIN
    PRINT N'Dọn dẹp phiếu mượn PMT999, PMT998...';
    DELETE FROM dbo.CO WHERE MaPhieu IN (N'PMT999', N'PMT998');
    DELETE FROM dbo.DANGKY WHERE MaPhieu IN (N'PMT999', N'PMT998');
    DELETE FROM dbo.PHIEUMUONTRA WHERE MaPhieu IN (N'PMT999', N'PMT998');
END
GO

IF EXISTS (SELECT 1 FROM dbo.SACH WHERE MaSach = N'S999')
BEGIN
    PRINT N'Dọn dẹp sách S999...';
    DELETE FROM dbo.CO WHERE MaSach = N'S999';
    DELETE FROM dbo.SACH WHERE MaSach = N'S999';
END
GO
IF EXISTS (SELECT 1 FROM dbo.TACGIA WHERE MaTacGia = N'TG999')
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.SACH WHERE MaTacGia = N'TG999')
    BEGIN
        PRINT N'Dọn dẹp tác giả TG999...';
        DELETE FROM dbo.TACGIA WHERE MaTacGia = N'TG999';
    END
END
GO
IF EXISTS (SELECT 1 FROM dbo.THELOAI WHERE MaTheLoai = N'TL999')
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.SACH WHERE MaTheLoai = N'TL999')
    BEGIN
        PRINT N'Dọn dẹp thể loại TL999...';
        DELETE FROM dbo.THELOAI WHERE MaTheLoai = N'TL999';
    END
END
GO

IF EXISTS (SELECT 1 FROM dbo.PHIEUMUONTRA WHERE MaPhieu = N'PMT001')
BEGIN
    PRINT N'Reset NgayHenTra cho PMT001.';
    UPDATE dbo.PHIEUMUONTRA SET NgayHenTra = '2024-04-15' WHERE MaPhieu = N'PMT001';
END
GO
PRINT N'--- 0. KẾT THÚC DỌN DẸP ---';
GO

-- PHẦN 1: THÊM SÁCH MỚI
-- Quyền: INSERT ON dbo.TACGIA, dbo.THELOAI, dbo.SACH; SELECT ON dbo.TACGIA, dbo.THELOAI
PRINT N'--- 1. Thủ thư thêm sách mới ---';
IF NOT EXISTS (SELECT 1 FROM dbo.TACGIA WHERE MaTacGia = N'TG999')
    INSERT INTO dbo.TACGIA (MaTacGia, TenTacGia, GioiTinhTacGia) VALUES (N'TG999', N'Tác Giả Mới Demo', N'Nam');
IF NOT EXISTS (SELECT 1 FROM dbo.THELOAI WHERE MaTheLoai = N'TL999')
    INSERT INTO dbo.THELOAI (MaTheLoai, TenTheLoai) VALUES (N'TL999', N'Thể Loại Mới Demo');
GO
INSERT INTO dbo.SACH (MaSach, TenSach, NamXuatBan, MaTheLoai, MaTacGia)
VALUES (N'S999', N'Lập trình SQL từ A đến Z (Demo)', '2024-01-15', N'TL999', N'TG999');
PRINT N'Đã thêm sách S999.';
GO

-- PHẦN 2: SỬA THÔNG TIN SÁCH
-- Quyền: UPDATE ON dbo.SACH; SELECT ON dbo.SACH
PRINT N'--- 2. Thủ thư sửa thông tin sách ---';
UPDATE dbo.SACH SET TenSach = N'Lập trình SQL nâng cao (Demo Updated)' WHERE MaSach = N'S999';
PRINT N'Đã cập nhật tên sách S999.';
GO

-- PHẦN 3: XÓA SÁCH (NẾU CHƯA ĐƯỢC MƯỢN)
-- Quyền: DELETE ON dbo.SACH; SELECT ON dbo.SACH, dbo.CO
PRINT N'--- 3. Thủ thư xóa sách S999 ---';
IF EXISTS (SELECT 1 FROM dbo.SACH WHERE MaSach = N'S999') AND
   NOT EXISTS (SELECT 1 FROM dbo.CO WHERE MaSach = N'S999')
BEGIN
    DELETE FROM dbo.SACH WHERE MaSach = N'S999';
    PRINT N'Đã xóa sách S999.';
END
ELSE
    PRINT N'Không thể xóa sách S999.';
GO

-- PHẦN 4: TẠO PHIẾU MƯỢN SÁCH
-- Quyền: EXECUTE ON dbo.sp_ThemPhieuMuon; SELECT ON dbo.PHIEUMUONTRA, dbo.DANGKY, dbo.CO
PRINT N'--- 4. Thủ thư tạo phiếu mượn sách (PMT999) ---';
EXEC dbo.sp_ThemPhieuMuon
    @MaPhieu      = N'PMT999', @MaDocGia     = N'DG002', @MaThuThu     = N'TT001',
    @NgayMuon     = '2024-05-01', @NgayHenTra   = '2024-05-15', @DanhSachSach = N'S001,S004';
PRINT N'Đã thêm phiếu mượn PMT999.';
GO
SELECT * FROM dbo.PHIEUMUONTRA WHERE MaPhieu = N'PMT999';
SELECT * FROM dbo.DANGKY WHERE MaPhieu = N'PMT999';
SELECT * FROM dbo.CO WHERE MaPhieu = N'PMT999';
GO

-- PHẦN 5: GHI NHẬN TRẢ SÁCH
-- Quyền: EXECUTE ON dbo.sp_TraSach; SELECT ON dbo.CO, dbo.PHIEUMUONTRA
PRINT N'--- 5. Thủ thư ghi nhận trả sách cho PMT999 ---';
PRINT N'Trả sách S001 cho PMT999:';
IF EXISTS (SELECT 1 FROM dbo.CO WHERE MaPhieu = N'PMT999' AND MaSach = N'S001' AND DaTra = 0)
BEGIN
    EXEC dbo.sp_TraSach @MaPhieu = N'PMT999', @MaSach  = N'S001', @NgayTra = '2024-05-10';
    PRINT N'DG002 đã trả sách S001 của PMT999.';
END
ELSE PRINT N'Sách S001 của PMT999 không cần trả.';
GO
SELECT * FROM dbo.CO WHERE MaPhieu = N'PMT999' AND MaSach = N'S001';
SELECT NgayTra FROM dbo.PHIEUMUONTRA WHERE MaPhieu = N'PMT999';
GO

PRINT N'Trả sách S004 cho PMT999:';
IF EXISTS (SELECT 1 FROM dbo.CO WHERE MaPhieu = N'PMT999' AND MaSach = N'S004' AND DaTra = 0)
BEGIN
    EXEC dbo.sp_TraSach @MaPhieu = N'PMT999', @MaSach  = N'S004', @NgayTra = '2024-05-12';
    PRINT N'DG002 đã trả sách S004 của PMT999. Phiếu hoàn tất.';
END
ELSE PRINT N'Sách S004 của PMT999 không cần trả.';
GO
SELECT * FROM dbo.CO WHERE MaPhieu = N'PMT999' AND MaSach = N'S004';
SELECT NgayTra FROM dbo.PHIEUMUONTRA WHERE MaPhieu = N'PMT999';
GO

-- PHẦN 6: THEO DÕI TÌNH TRẠNG SÁCH
-- Quyền: SELECT ON dbo.VIEW_PHIEUMUONTRA_CHUATRA_FIXED, dbo.VIEW_SACH_QUAHAN
PRINT N'--- 6. Thủ thư theo dõi tình trạng sách ---';
PRINT N'Danh sách phiếu mượn chưa trả toàn bộ:';
SELECT * FROM dbo.VIEW_PHIEUMUONTRA_CHUATRA_FIXED;
GO
PRINT N'Danh sách sách mượn quá hạn:';
SELECT * FROM dbo.VIEW_SACH_QUAHAN;
GO

-- PHẦN 7: HỖ TRỢ ĐĂNG KÝ (Thêm phiếu mượn mới PMT998)
-- Quyền: EXECUTE ON dbo.sp_ThemPhieuMuon; SELECT ON dbo.DANGKY, dbo.CO
PRINT N'--- 7. Thủ thư thêm phiếu mượn mới PMT998 ---';
EXEC dbo.sp_ThemPhieuMuon
    @MaPhieu      = N'PMT998', @MaDocGia     = N'DG001,DG003', @MaThuThu     = N'TT002',
    @NgayMuon     = '2024-05-02', @NgayHenTra   = '2024-05-20', @DanhSachSach = N'S005';
PRINT N'Đã thêm phiếu mượn PMT998.';
GO
SELECT * FROM dbo.DANGKY WHERE MaPhieu = N'PMT998';
SELECT * FROM dbo.CO WHERE MaPhieu = N'PMT998';
GO

-- PHẦN 8: GIA HẠN NGÀY HẸN TRẢ
-- Quyền: UPDATE ON dbo.PHIEUMUONTRA; SELECT ON dbo.PHIEUMUONTRA
PRINT N'--- 8. Thủ thư gia hạn phiếu mượn PMT001 ---';
IF EXISTS (SELECT 1 FROM dbo.PHIEUMUONTRA WHERE MaPhieu = N'PMT001' AND NgayTra IS NULL)
BEGIN
    PRINT N'NgayHenTra PMT001 (trước):';
    SELECT NgayHenTra FROM dbo.PHIEUMUONTRA WHERE MaPhieu = N'PMT001';
    UPDATE dbo.PHIEUMUONTRA SET NgayHenTra = DATEADD(day, 7, NgayHenTra) WHERE MaPhieu = N'PMT001';
    PRINT N'Đã gia hạn PMT001.';
    PRINT N'NgayHenTra PMT001 (sau):';
    SELECT NgayHenTra FROM dbo.PHIEUMUONTRA WHERE MaPhieu = N'PMT001';
END
ELSE PRINT N'Không thể gia hạn PMT001.';
GO

-- PHẦN 9: XEM THỐNG KÊ MƯỢN TRẢ
-- Quyền: EXECUTE ON dbo.sp_ThongKeMuonTra
PRINT N'--- 9. Thủ thư xem thống kê mượn trả ---';
EXEC dbo.sp_ThongKeMuonTra @TuNgay = '2024-01-01', @DenNgay = '2024-12-31';
GO

PRINT N'--- KẾT THÚC KỊCH BẢN DEMO ---';
GO
