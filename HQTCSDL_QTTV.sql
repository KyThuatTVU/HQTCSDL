
-- ==============================
-- TẠO DATABASE
-- ==============================
-- Tạo cơ sở dữ liệu HQTCSDL_QLTV (nếu chưa tồn tại)
IF DB_ID('HQTCSDL_QLTV') IS NULL
    CREATE DATABASE HQTCSDL_QLTV;
GO

-- Chuyển sang sử dụng cơ sở dữ liệu vừa tạo
USE HQTCSDL_QLTV;
GO

-- ==============================
-- XÓA BẢNG NẾU TỒN TẠI (Theo thứ tự ngược lại của khóa ngoại)
-- ==============================
IF OBJECT_ID('dbo.CO', 'U') IS NOT NULL DROP TABLE dbo.CO;
IF OBJECT_ID('dbo.DANGKY', 'U') IS NOT NULL DROP TABLE dbo.DANGKY;
IF OBJECT_ID('dbo.PHIEUMUONTRA', 'U') IS NOT NULL DROP TABLE dbo.PHIEUMUONTRA;
IF OBJECT_ID('dbo.SACH', 'U') IS NOT NULL DROP TABLE dbo.SACH;
IF OBJECT_ID('dbo.DOCGIA', 'U') IS NOT NULL DROP TABLE dbo.DOCGIA;
IF OBJECT_ID('dbo.THUTHU', 'U') IS NOT NULL DROP TABLE dbo.THUTHU;
IF OBJECT_ID('dbo.TACGIA', 'U') IS NOT NULL DROP TABLE dbo.TACGIA;
IF OBJECT_ID('dbo.THELOAI', 'U') IS NOT NULL DROP TABLE dbo.THELOAI;
GO

-- ==============================
-- I. TẠO BẢNG
-- ==============================
-- 1. BẢNG THỂ LOẠI
CREATE TABLE dbo.THELOAI (
    MaTheLoai   NVARCHAR(10)  PRIMARY KEY,
    TenTheLoai  NVARCHAR(50)  NOT NULL -- Tăng kích thước
);
GO

-- 2. BẢNG TÁC GIẢ
CREATE TABLE dbo.TACGIA (
    MaTacGia          NVARCHAR(10)  PRIMARY KEY,
    TenTacGia         NVARCHAR(50)  NOT NULL, -- Tăng kích thước
    GioiTinhTacGia    NVARCHAR(10)  NULL
);
GO

-- 3. BẢNG SÁCH
CREATE TABLE dbo.SACH (
    MaSach       NVARCHAR(10)  PRIMARY KEY,
    TenSach      NVARCHAR(100) NOT NULL, -- Tăng kích thước đáng kể
    NamXuatBan   DATE          NULL,
    MaTheLoai    NVARCHAR(10)  NOT NULL,
    MaTacGia     NVARCHAR(10)  NOT NULL,
    CONSTRAINT FK_SACH_THELOAI FOREIGN KEY (MaTheLoai)
        REFERENCES dbo.THELOAI(MaTheLoai),
    CONSTRAINT FK_SACH_TACGIA   FOREIGN KEY (MaTacGia)
        REFERENCES dbo.TACGIA(MaTacGia)
);
GO

-- 4. BẢNG THỦ THƯ
CREATE TABLE dbo.THUTHU (
    MaThuThu           NVARCHAR(10)  PRIMARY KEY,
    TenThuThu          NVARCHAR(50)  NOT NULL, -- Tăng kích thước
    NgaySinhThuThu     DATE          NULL,
    DienThoaiThuThu    NVARCHAR(15)  NULL,
    GioiTinhThuThu     NVARCHAR(10)  NULL
);
GO

-- 5. BẢNG ĐỘC GIẢ
CREATE TABLE dbo.DOCGIA (
    MaDocGia          NVARCHAR(10)  PRIMARY KEY,
    TenDocGia         NVARCHAR(50)  NOT NULL, -- Giữ nguyên, có vẻ đủ
    SoDienThoai       NVARCHAR(15)  NULL,
    GioiTinhDocGia    NVARCHAR(10)  NULL,
    NamSinhDocGia     DATE          NULL
);
GO

-- 6. BẢNG PHIẾU MƯỢN TRẢ
CREATE TABLE dbo.PHIEUMUONTRA (
    MaPhieu        NVARCHAR(15)  PRIMARY KEY,
    NgayMuon       DATE          NOT NULL,
    NgayTra        DATE          NULL,
    SoLuong        INT           NULL,
    NgayHenTra     DATE          NULL,
    MaThuThu       NVARCHAR(10)  NOT NULL,
    CONSTRAINT FK_PM_TR_ThuThu FOREIGN KEY (MaThuThu)
        REFERENCES dbo.THUTHU(MaThuThu)
);
GO

-- 7. BẢNG ĐĂNG KÝ (Độc giả – Phiếu mượn: N–N)
CREATE TABLE dbo.DANGKY (
    MaDocGia  NVARCHAR(10)  NOT NULL,
    MaPhieu   NVARCHAR(15)  NOT NULL,
    CONSTRAINT PK_DANGKY PRIMARY KEY (MaDocGia, MaPhieu),
    CONSTRAINT FK_DK_DocGia FOREIGN KEY (MaDocGia)
        REFERENCES dbo.DOCGIA(MaDocGia),
    CONSTRAINT FK_DK_Phieu   FOREIGN KEY (MaPhieu)
        REFERENCES dbo.PHIEUMUONTRA(MaPhieu)
);
GO

-- 8. BẢNG CÓ (Sách – Phiếu mượn: N–N)
CREATE TABLE dbo.CO (
    MaSach   NVARCHAR(10)  NOT NULL,
    MaPhieu  NVARCHAR(15)  NOT NULL,
    GhiChu   NVARCHAR(200) NULL,
    DaTra    INT           DEFAULT 0,    -- 0: chưa trả, 1: đã trả
    CONSTRAINT PK_CO PRIMARY KEY (MaSach, MaPhieu),
    CONSTRAINT FK_CO_Sach   FOREIGN KEY (MaSach)
        REFERENCES dbo.SACH(MaSach),
    CONSTRAINT FK_CO_Phieu  FOREIGN KEY (MaPhieu)
        REFERENCES dbo.PHIEUMUONTRA(MaPhieu)
);
GO

-- ==============================
-- II. CHÈN DỮ LIỆU MẪU
-- ==============================
-- 1. BẢNG THỂ LOẠI
INSERT INTO dbo.THELOAI (MaTheLoai, TenTheLoai) VALUES
  (N'TL001', N'Văn học'),
  (N'TL002', N'Khoa học'),
  (N'TL003', N'Lịch sử'),
  (N'TL004', N'Ngôn tình'),
  (N'TL005', N'Tâm lý');
GO

-- 2. BẢNG TÁC GIẢ
INSERT INTO dbo.TACGIA (MaTacGia, TenTacGia, GioiTinhTacGia) VALUES
  (N'TG001', N'Nguyễn Nhật Ánh', N'Nam'),
  (N'TG002', N'Haruki Murakami', N'Nam'),
  (N'TG003', N'Tuệ Nghi', N'Nữ'),
  (N'TG004', N'George Orwell', N'Nam'),
  (N'TG005', N'Jane Austen', N'Nữ');
GO

-- 3. BẢNG SÁCH
INSERT INTO dbo.SACH (MaSach, TenSach, NamXuatBan, MaTheLoai, MaTacGia) VALUES
  (N'S001', N'Cho tôi xin một vé đi tuổi thơ',  '2008-01-01', N'TL001', N'TG001'),
  (N'S002', N'Kafka bên bờ biển',            '2002-09-12', N'TL002', N'TG002'),
  (N'S003', N'1984',                          '1949-06-08', N'TL003', N'TG004'),
  (N'S004', N'Nỗi buồn chim vé vèo',          '2019-05-20', N'TL004', N'TG003'),
  (N'S005', N'Kiêu hãnh và định kiến',        '1813-01-28', N'TL005', N'TG005');
GO

-- 4. BẢNG THỦ THƯ
INSERT INTO dbo.THUTHU (MaThuThu, TenThuThu, NgaySinhThuThu, DienThoaiThuThu, GioiTinhThuThu) VALUES
  (N'TT001', N'Lê Thu Hằng',   '1985-03-15', N'0912345678', N'Nữ'),
  (N'TT002', N'Phạm Văn Quang','1978-11-02', N'0987654321', N'Nam');
GO

-- 5. BẢNG ĐỘC GIẢ
INSERT INTO dbo.DOCGIA (MaDocGia, TenDocGia, SoDienThoai, GioiTinhDocGia, NamSinhDocGia) VALUES
  (N'DG001', N'Nguyễn Văn A', N'0901111222', N'Nam', '1990-06-10'),
  (N'DG002', N'Trần Thị B',   N'0903333444', N'Nữ',  '1992-08-25'),
  (N'DG003', N'Phan Minh C',  N'0905555666', N'Nam', '1988-12-05');
GO

-- 6. BẢNG PHIẾU MƯỢN TRẢ
-- Sửa lại ngày tháng cho hợp lý hơn (không dùng năm tương lai xa)
INSERT INTO dbo.PHIEUMUONTRA (MaPhieu, NgayMuon, NgayTra, SoLuong, NgayHenTra, MaThuThu) VALUES
  (N'PMT001', '2024-04-01', NULL, 2, '2024-04-15', N'TT001'),
  (N'PMT002', '2024-04-03', '2024-04-10', 1, '2024-04-17', N'TT002'),
  (N'PMT003', '2024-04-05', NULL, 2, '2024-04-20', N'TT001'); -- Sửa SoLuong = 2 để khớp bảng CO
GO

-- 7. BẢNG ĐĂNG KÝ (Độc giả ↔ Phiếu mượn)
INSERT INTO dbo.DANGKY (MaDocGia, MaPhieu) VALUES
  (N'DG001', N'PMT001'),
  (N'DG002', N'PMT002'),
  (N'DG001', N'PMT003'),
  (N'DG003', N'PMT003');
GO

-- 8. BẢNG CÓ (Sách ↔ Phiếu mượn)
INSERT INTO dbo.CO (MaSach, MaPhieu, GhiChu, DaTra) VALUES
  (N'S001', N'PMT001', N'Xuất bản lần 1', 0),
  (N'S003', N'PMT001', N'Giáo trình bổ sung', 0),
  (N'S002', N'PMT002', N'Phiên bản tiếng Anh', 1), -- Sách này đã trả (khớp NgayTra ở PMT002)
  (N'S004', N'PMT003', N'Bản mới in 2024', 0),
  (N'S005', N'PMT003', N'Bản tái bản', 0);
GO

-- ==============================
-- HIỂN THỊ DỮ LIỆU CÁC BẢNG
-- ==============================
SELECT * FROM dbo.THELOAI;
SELECT * FROM dbo.TACGIA;
SELECT * FROM dbo.SACH;
SELECT * FROM dbo.THUTHU;
SELECT * FROM dbo.DOCGIA;
SELECT * FROM dbo.PHIEUMUONTRA;
SELECT * FROM dbo.DANGKY;
SELECT * FROM dbo.CO;
GO

-- ==============================
-- III. VIEW
-- ==============================

-- 1. VIEW_SACH_CHITIET
DROP VIEW IF EXISTS dbo.VIEW_SACH_CHITIET;
GO
CREATE VIEW dbo.VIEW_SACH_CHITIET AS
SELECT
  S.MaSach,
  S.TenSach,
  S.NamXuatBan,
  TL.TenTheLoai AS TheLoai,
  TG.TenTacGia  AS TacGia
FROM dbo.SACH S
JOIN dbo.THELOAI TL ON S.MaTheLoai = TL.MaTheLoai
JOIN dbo.TACGIA  TG ON S.MaTacGia   = TG.MaTacGia;
GO
SELECT * FROM dbo.VIEW_SACH_CHITIET WHERE MaSach = N'S999';
GO

-- 2. VIEW_PHIEUMUON_CHUATRA
DROP VIEW IF EXISTS dbo.VIEW_PHIEUMUON_CHUATRA;
GO
CREATE VIEW dbo.VIEW_PHIEUMUON_CHUATRA AS
WITH SachChuaTra AS (
  SELECT
    P.MaPhieu,
    P.NgayMuon,
    P.NgayHenTra,
    P.MaThuThu,
    C.MaSach
  FROM dbo.PHIEUMUONTRA P
  JOIN dbo.CO C
    ON P.MaPhieu = C.MaPhieu
   AND C.DaTra = 0
  WHERE P.NgayTra IS NULL
),
DanhSachSach AS (
  SELECT
    MaPhieu,
    STRING_AGG(S.TenSach, N', ') 
      WITHIN GROUP (ORDER BY S.TenSach) AS DanhSachSachChuaTra
  FROM SachChuaTra SCT
  JOIN dbo.SACH S
    ON SCT.MaSach = S.MaSach
  GROUP BY MaPhieu
),
DanhSachDocGia AS (
  SELECT
    DK.MaPhieu,
    STRING_AGG(DG.TenDocGia, N', ')
      WITHIN GROUP (ORDER BY DG.TenDocGia) AS DanhSachDocGia
  FROM dbo.DANGKY DK
  JOIN dbo.DOCGIA DG
    ON DK.MaDocGia = DG.MaDocGia
  GROUP BY DK.MaPhieu
)
SELECT
  SCT.MaPhieu,
  SCT.NgayMuon,
  SCT.NgayHenTra,
  TT.TenThuThu AS Thuthu,
  DSs.DanhSachSachChuaTra,
  DD.DanhSachDocGia
FROM SachChuaTra SCT
JOIN dbo.THUTHU TT
  ON SCT.MaThuThu = TT.MaThuThu
LEFT JOIN DanhSachSach DSs
  ON SCT.MaPhieu = DSs.MaPhieu
LEFT JOIN DanhSachDocGia DD
  ON SCT.MaPhieu = DD.MaPhieu;
GO

-- 3. VIEW_SACH_QUAHAN
DROP VIEW IF EXISTS dbo.VIEW_SACH_QUAHAN;
GO
CREATE VIEW dbo.VIEW_SACH_QUAHAN AS
SELECT
  P.MaPhieu,
  DG.TenDocGia,
  S.MaSach,
  S.TenSach,
  P.NgayHenTra,
  DATEDIFF(day, P.NgayHenTra, CAST(GETDATE() AS date)) AS SoNgayQuaHan
FROM dbo.PHIEUMUONTRA P
JOIN dbo.CO      C  ON P.MaPhieu = C.MaPhieu
JOIN dbo.SACH    S  ON C.MaSach  = S.MaSach
JOIN dbo.DANGKY  DK ON P.MaPhieu = DK.MaPhieu
JOIN dbo.DOCGIA  DG ON DK.MaDocGia = DG.MaDocGia
WHERE C.DaTra = 0
  AND P.NgayHenTra < CAST(GETDATE() AS date);
GO

-- 4. VIEW_DOCGIA_THONGKE
DROP VIEW IF EXISTS dbo.VIEW_DOCGIA_THONGKE;
GO
CREATE VIEW dbo.VIEW_DOCGIA_THONGKE AS
SELECT
  DG.MaDocGia,
  DG.TenDocGia,
  COUNT(DISTINCT DK.MaPhieu)                           AS SoPhieuDaTungMuon,
  SUM(CASE WHEN C.DaTra = 1 THEN 1 ELSE 0 END)         AS TongSoSachDaTra,
  SUM(CASE WHEN C.DaTra = 0 THEN 1 ELSE 0 END)         AS TongSoSachChuaTra
FROM dbo.DOCGIA DG
LEFT JOIN dbo.DANGKY DK ON DG.MaDocGia = DK.MaDocGia
LEFT JOIN dbo.CO     C  ON DK.MaPhieu  = C.MaPhieu
GROUP BY DG.MaDocGia, DG.TenDocGia;
GO
-- ==============================
-- IV. TRIGGER
-- ==============================

-- 1. trg_SACH_CheckPubDate
DROP TRIGGER IF EXISTS trg_SACH_CheckPubDate;
GO
CREATE TRIGGER trg_SACH_CheckPubDate
  ON dbo.SACH
  AFTER INSERT, UPDATE
AS
BEGIN
  IF EXISTS (
    SELECT 1 FROM inserted
    WHERE NamXuatBan > CAST(GETDATE() AS date)
  )
  BEGIN
    RAISERROR(N'Ngày xuất bản không thể ở tương lai.',16,1);
    ROLLBACK TRANSACTION;
  END
END;
GO

-- 2. trg_THUTHU_CheckBirthDate
DROP TRIGGER IF EXISTS trg_THUTHU_CheckBirthDate;
GO
CREATE TRIGGER trg_THUTHU_CheckBirthDate
  ON dbo.THUTHU
  AFTER INSERT, UPDATE
AS
BEGIN
  IF EXISTS (
    SELECT 1 FROM inserted
    WHERE NgaySinhThuThu > CAST(GETDATE() AS date)
  )
  BEGIN
    RAISERROR(N'Ngày sinh thủ thư không thể ở tương lai.',16,1);
    ROLLBACK TRANSACTION;
  END
END;
GO

-- 3. trg_DOCGIA_CheckBirthDate
DROP TRIGGER IF EXISTS trg_DOCGIA_CheckBirthDate;
GO
CREATE TRIGGER trg_DOCGIA_CheckBirthDate
  ON dbo.DOCGIA
  AFTER INSERT, UPDATE
AS
BEGIN
  IF EXISTS (
    SELECT 1 FROM inserted
    WHERE NamSinhDocGia > CAST(GETDATE() AS date)
  )
  BEGIN
    RAISERROR(N'Năm sinh độc giả không thể ở tương lai.',16,1);
    ROLLBACK TRANSACTION;
  END
END;
GO

-- 4. trg_PHIEUMUONTRA_CheckDates
DROP TRIGGER IF EXISTS trg_PHIEUMUONTRA_CheckDates;
GO
CREATE TRIGGER trg_PHIEUMUONTRA_CheckDates
  ON dbo.PHIEUMUONTRA
  AFTER INSERT, UPDATE
AS
BEGIN
  IF EXISTS (
    SELECT 1 FROM inserted
    WHERE (NgayHenTra IS NOT NULL AND NgayHenTra < NgayMuon)
       OR (NgayTra    IS NOT NULL AND NgayTra    < NgayMuon)
       OR (
         NgayHenTra IS NOT NULL
     AND NgayTra    IS NOT NULL
     AND DATEDIFF(day, NgayHenTra, NgayTra) > 365
       )
  )
  BEGIN
    RAISERROR(N'Ngày hẹn/trả sai logic (quá sớm hoặc quá trễ).',16,1);
    ROLLBACK TRANSACTION;
  END
END;
GO

-- 5. trg_CO_UpdateSoLuong
DROP TRIGGER IF EXISTS trg_CO_UpdateSoLuong;
GO
CREATE TRIGGER trg_CO_UpdateSoLuong
  ON dbo.CO
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @P TABLE(MaPhieu NVARCHAR(15) PRIMARY KEY);
  INSERT INTO @P SELECT DISTINCT MaPhieu FROM inserted
   UNION
  SELECT DISTINCT MaPhieu FROM deleted;

  UPDATE T
  SET SoLuong = ISNULL(C.BookCount,0)
  FROM dbo.PHIEUMUONTRA T
  LEFT JOIN (
    SELECT MaPhieu, COUNT(*) AS BookCount
    FROM dbo.CO
    WHERE MaPhieu IN (SELECT MaPhieu FROM @P)
    GROUP BY MaPhieu
  ) C ON T.MaPhieu = C.MaPhieu
  WHERE T.MaPhieu IN (SELECT MaPhieu FROM @P);
END;
GO


-- ==============================
-- V. THỦ TỤC (PROCEDURES)
-- ==============================

-- 1. sp_ThemPhieuMuon
GO
CREATE OR ALTER PROCEDURE dbo.sp_ThemPhieuMuon
  @MaPhieu      NVARCHAR(15),
  @MaDocGia     NVARCHAR(MAX),  -- 'DG001,DG002'
  @MaThuThu     NVARCHAR(10),
  @NgayMuon     DATE,
  @NgayHenTra   DATE,
  @DanhSachSach NVARCHAR(MAX)   -- 'S001,S002'
AS
BEGIN
  SET NOCOUNT ON;
  BEGIN TRAN;
  BEGIN TRY
    -- Kiểm tồn tại phiếu, thủ thư, độc giả, sách...
    IF EXISTS(SELECT 1 FROM dbo.PHIEUMUONTRA WHERE MaPhieu=@MaPhieu)
      THROW 50000, N'Phieu da ton tai', 1;
    DECLARE @xmlDG XML = CAST('<r><i>'+REPLACE(@MaDocGia,',','</i><i>')+'</i></r>' AS XML),
            @xmlS  XML = CAST('<r><i>'+REPLACE(@DanhSachSach,',','</i><i>')+'</i></r>' AS XML);

    -- Tạo phiếu
    INSERT INTO dbo.PHIEUMUONTRA(MaPhieu,NgayMuon,NgayHenTra,SoLuong,MaThuThu)
    VALUES(@MaPhieu,@NgayMuon,@NgayHenTra,0,@MaThuThu);

    -- Ghi DANGKY
    INSERT INTO dbo.DANGKY(MaDocGia,MaPhieu)
    SELECT T.N.value('.','NVARCHAR(10)'), @MaPhieu
    FROM @xmlDG.nodes('/r/i') AS T(N);

    -- Ghi CO
    INSERT INTO dbo.CO(MaSach,MaPhieu,GhiChu,DaTra)
    SELECT T.N.value('.','NVARCHAR(10)'), @MaPhieu, N'Auto', 0
    FROM @xmlS.nodes('/r/i') AS T(N);

    -- Cập nhật SoLuong
    UPDATE dbo.PHIEUMUONTRA
    SET SoLuong = (SELECT COUNT(*) FROM dbo.CO WHERE MaPhieu=@MaPhieu)
    WHERE MaPhieu=@MaPhieu;

    COMMIT;
  END TRY
  BEGIN CATCH
    ROLLBACK;
    THROW;
  END CATCH
END;
GO

-- 2. sp_TraSach
GO
CREATE OR ALTER PROCEDURE dbo.sp_TraSach
  @MaPhieu   NVARCHAR(15),
  @MaSach    NVARCHAR(10),
  @NgayTra   DATE
AS
BEGIN
  SET NOCOUNT ON;
  BEGIN TRAN;
  BEGIN TRY
    UPDATE dbo.CO
    SET DaTra = 1
    WHERE MaPhieu=@MaPhieu AND MaSach=@MaSach;

    IF NOT EXISTS(SELECT 1 FROM dbo.CO WHERE MaPhieu=@MaPhieu AND DaTra=0)
      UPDATE dbo.PHIEUMUONTRA
      SET NgayTra=@NgayTra
      WHERE MaPhieu=@MaPhieu;

    COMMIT;
  END TRY
  BEGIN CATCH
    ROLLBACK;
    THROW;
  END CATCH
END;
GO

-- 3. sp_ThongKeMuonTra
GO
CREATE OR ALTER PROCEDURE dbo.sp_ThongKeMuonTra
  @TuNgay DATE,
  @DenNgay DATE
AS
BEGIN
  SET NOCOUNT ON;
  SELECT
    DG.MaDocGia,
    DG.TenDocGia,
    COUNT(DISTINCT P.MaPhieu) AS TongPhieu,
    SUM(CASE WHEN P.NgayTra IS NOT NULL THEN 1 ELSE 0 END) AS DaTra,
    SUM(CASE WHEN P.NgayTra IS NULL THEN 1 ELSE 0 END) AS ChuaTra,
    ISNULL(SUM(COUNT_CO),0) AS TongSach
  FROM dbo.DOCGIA DG
  JOIN dbo.DANGKY DK ON DG.MaDocGia=DK.MaDocGia
  JOIN dbo.PHIEUMUONTRA P ON DK.MaPhieu=P.MaPhieu
  LEFT JOIN (
    SELECT MaPhieu, COUNT(*) AS COUNT_CO
    FROM dbo.CO GROUP BY MaPhieu
  ) C ON P.MaPhieu=C.MaPhieu
  WHERE P.NgayMuon BETWEEN @TuNgay AND @DenNgay
  GROUP BY DG.MaDocGia, DG.TenDocGia
  ORDER BY TongPhieu DESC;
END;
GO

-- Phân quyền 
-- 1. Tạo các Database Role
CREATE ROLE db_Librarian;    -- Thủ thư
CREATE ROLE db_Reader;       -- Độc giả
CREATE ROLE db_Admin;        -- Admin
GO

-- 2. Tạo Login và User rồi gán vào Role
-- 2.1 Thủ thư
CREATE LOGIN login_ThuThu WITH PASSWORD = 'StrongP@ss1!';
CREATE USER user_ThuThu FOR LOGIN login_ThuThu;
ALTER ROLE db_Librarian ADD MEMBER user_ThuThu;

-- 2.2 Độc giả
CREATE LOGIN login_DocGia WITH PASSWORD = 'StrongP@ss2!';
CREATE USER user_DocGia FOR LOGIN login_DocGia;
ALTER ROLE db_Reader ADD MEMBER user_DocGia;

-- 2.3 Admin
CREATE LOGIN login_Admin WITH PASSWORD = 'StrongP@ss3!';
CREATE USER user_Admin FOR LOGIN login_Admin;
ALTER ROLE db_Admin ADD MEMBER user_Admin;

-- VI. Quản trị hệ thống + CSDL (Server-level)

-- 3. Phân quyền chi tiết trên database

-- 3.1 Quyền của Thủ thư (db_Librarian): CRUD trên SACH, TACGIA, THELOAI, PHIEUMUONTRA, DANGKY, CO
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.SACH          TO db_Librarian;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.TACGIA        TO db_Librarian;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.THELOAI       TO db_Librarian;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.PHIEUMUONTRA  TO db_Librarian;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.DANGKY        TO db_Librarian;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.CO            TO db_Librarian;
-- Bổ sung quyền EXECUTE cho các stored procedures
GRANT EXECUTE ON dbo.sp_ThemPhieuMuon   TO db_Librarian;
GRANT EXECUTE ON dbo.sp_TraSach         TO db_Librarian;
GRANT EXECUTE ON dbo.sp_ThongKeMuonTra  TO db_Librarian;

-- Cho phép xem view theo dõi chưa trả
GRANT SELECT ON dbo.VIEW_PHIEUMUON_CHUATRA TO db_Librarian;

-- Cho phép xem view sách quá hạn
GRANT SELECT ON dbo.VIEW_SACH_QUAHAN TO db_Librarian;


-- 3.2 Quyền của Độc giả (db_Reader)
GRANT SELECT ON dbo.SACH           TO db_Reader;
GRANT SELECT ON dbo.THELOAI        TO db_Reader;
GRANT SELECT ON dbo.TACGIA         TO db_Reader;

GRANT SELECT, UPDATE ON dbo.DOCGIA TO db_Reader WITH GRANT OPTION;

GRANT INSERT, DELETE ON dbo.DANGKY TO db_Reader;

GRANT SELECT ON dbo.PHIEUMUONTRA   TO db_Reader;
GRANT SELECT ON dbo.CO             TO db_Reader;
GO

-- 3.3 Quyền của Admin (db_Admin)
GRANT ALTER ANY USER      TO db_Admin;  
GRANT ALTER ANY ROLE      TO db_Admin;  
GRANT VIEW DEFINITION     ON DATABASE::HQTCSDL_QLTV TO db_Admin;
GO