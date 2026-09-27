use Quan_ly_tranh_thu;
go
drop table if exists CapDonVi;
go
create table CapDonVi(
MaCapDV varchar(10) not null primary key,
TenCapDV nvarchar(50) not null,
)
go
create table DonVi(
MaDV varchar(10) not null primary key,
TenDV nvarchar(50) not null,
MaCapDV varchar(10) not null,
MaDVCha varchar(10) null,
CONSTRAINT FK_DonVi_CapDonVi FOREIGN KEY (MaCapDV) REFERENCES CapDonVi(MaCapDV),
CONSTRAINT FK_DonVi_DonViCha FOREIGN KEY (MaDVCha) REFERENCES DonVi(MaDV)
);
go
create table CapBac(
MaCB nvarchar(10) not null primary key,
TenCB nvarchar(50) not null,
ThuTu int not null,
constraint UQ_CapBac_ThuTu unique (ThuTu));
go
create table DoiTuong(
MaDT nvarchar(10) not null primary key,
TenDT nvarchar(50) not null,
MoTa nvarchar(255) null);
go
create table ChucVu(
MaCV nvarchar(10) not null primary key,
TenCV nvarchar(20) not null);
go
create table QuanNhan(
MaQN nvarchar(10) not null primary key,
HoTen nvarchar(50) not null,
NgaySinh date not null,
GioiTinh nvarchar(5) not null,
QueQuan nvarchar(255) not null,
NgayNhapNgu date not null,
SDT nvarchar(20) not null,
TinhTrang nvarchar(20) not null default N'Tạo ngũ',
MaDV nvarchar(10) not null,
MaCB nvarchar(10) not null,
MaDT nvarchar(10) not null,
MaCV nvarchar(10) not null,
constraint FK_QuanNhan_DonVi foreign key (MaDV) references DonVi(MaDV),
constraint fk_QuanNhan_CapBac foreign key (MaCB) references CapBac(MaCB),
constraint fk_QuanNhan_ChucVu foreign key (MaCV) references ChucVu(MaCV),
constraint fk_QuanNhan_DoiTuong foreign key (MaDT) references DoiTuong(MaDT),
constraint ck_QuanNhan_GioiTinh check (GioiTinh in(N'Nam', N'Nữ')),
constraint ck_QuanNhan_TinhTrang check (TinhTrang in (N'Tại ngũ', N'Đang tranh thủ'))
);
go
create table NguoiThan(
MaNT nvarchar(10) not null primary key,
MaQN nvarchar(10) not null,
HoTen nvarchar(100) not null,
MoiQuanHe nvarchar(10) null,
DiaChi nvarchar(255) null,
SDT nvarchar(20) not null,
constraint fk_NguoiThan_QuanNhan foreign key (MaQN) references QuanNhan(MaQN));
go
create table VaiTro(
MaVaiTro nvarchar(10) not null primary key,
TenVaiTro nvarchar(20) not null,
MoTa nvarchar(155) null);
go
create table NguoiDung(
MaNguoiDung nvarchar(10) not null primary key,
MaQN nvarchar (10) not null,
MaVaiTro nvarchar(10) not null,
TenDangNhap nvarchar(50) not null,
MatKhau nvarchar(255) not null,
TrangThai nvarchar(20) not null default N'Hoạt động',
constraint uq_NguoiDung_MaQN unique (MaQN),
constraint uq_NguoiDung_TenDangNhap unique (TenDangNhap),
constraint fk_NguoiDung_QuanNhan foreign key (MaQN) references QuanNhan (MaQN),
constraint fk_NGuoiDung_VaiTro foreign key (MaVaiTro) references VaiTro(MaVaiTro),
constraint ck_NguoiDung_TrangThai check (TrangThai in(N'Hoạt động',N'Khóa')));
go
create table LichSuHeThong(
MaLichSu bigint not null identity(1,1) primary key,
MaNguoiDung nvarchar(10) not null,
ThoiGian datetime2 not null default sysdatetime(),
HanhDong nvarchar(255) not null,
DiaChiIP nvarchar(50) null,
constraint fk_LichSuHeThong_NguoiDung foreign key (MaNguoiDung) references NguoiDung(MaNguoiDung));
go
create table LoaiPhep(
MaLoaiPhep nvarchar(10) not null primary key,
TenLoaiPhep nvarchar(50) not null,
SoNgayToiDa int not null,
MoTa nvarchar(255) null,
constraint ck_LoaiPhep_SoNgay check(SoNgayToiDa>0));
go
create table DonTranhThu(
MaDon nvarchar(10) not null primary key,
MaQN nvarchar(10) not null,
MaLoaiPhep nvarchar(10) not null,
NgayLamDon datetime2 not null default sysdatetime(),
LyDo nvarchar(255) not null,
NgayBatDau date not null,
NgayKetThuc date not null,
NoiDen nvarchar(255) not null,
DiaChiChiTiet nvarchar(255) not null,
TrangThai nvarchar(20) not null default N'Chờ duyệt',
constraint fk_DonTranhThu_QuanNhan foreign key (MaQN) references QuanNhan(MaQN),
constraint fk_DonTranhThu_LoaiPhep foreign key (MaLoaiPhep) references LoaiPhep(MaLoaiPhep),
constraint ck_DonTranhThu_NgayHopLe check (NgayKetThuc>=NgayBatDau),
constraint ck_DonTranhThu_TrangThai check (TrangThai in (N'Chờ duyệt', N'Đã duyệt',N'Từ chối',N'Đang tranh thủ', N'Đã về')));
go
create table PheDuyet(
MaPD nvarchar(10) not null primary key,
MaDon nvarchar(10) not null,
MaNguoiDuyet nvarchar(10) not null,
CapDuyet nvarchar(50) not null,
KetQua nvarchar(10) not null,
NoiDung nvarchar(255) null,
constraint fk_PheDuyet_DonTranhThu foreign key (MaDon) references DonTranhThu (MaDon),
constraint fk_PheDuyet_NguoiDung foreign key (MaNguoiDuyet) references NguoiDung(MaNguoiDung),
constraint ck_PheDuyet_KetQua check (KetQua in (N'Chấp nhận', N'Từ chối')));
go
create table LichSuTranhThu(
MaLS nvarchar(10) not null primary key,
MaDon nvarchar(10) not null,
ThoiGianDi datetime2 null,
ThoiGianVe datetime2 null,
TrangThai nvarchar(20) null,
GhiChu nvarchar(255) null,
constraint fk_LichSuTranhThu_DonTranhThu foreign key (MaDon) references DonTranhThu(MaDon),
constraint ck_LichSuTranhThu_ThoiGian check(ThoiGianVe is null or ThoiGianVe >= ThoiGianDi),
constraint ck_LichSuTranhThu_TrangThai check(TrangThai is null or TrangThai in (N'Đúng hạn',N'Trễ hạn', N'Chưa về')));
go
CREATE INDEX IDX_QuanNhan_DonVi         ON QuanNhan(MaDV);
CREATE INDEX IDX_DonTranhThu_QuanNhan   ON DonTranhThu(MaQN);
CREATE INDEX IDX_DonTranhThu_TrangThai  ON DonTranhThu(TrangThai);
CREATE INDEX IDX_PheDuyet_MaDon         ON PheDuyet(MaDon);
CREATE INDEX IDX_LichSuHeThong_ThoiGian ON LichSuHeThong(ThoiGian);
GO


















