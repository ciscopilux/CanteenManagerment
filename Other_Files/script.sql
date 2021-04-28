USE [master]
GO
/****** Object:  Database [CanteenManagement]    Script Date: 4/28/2021 3:27:39 PM ******/
CREATE DATABASE [CanteenManagement]
GO
ALTER DATABASE [CanteenManagement] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [CanteenManagement].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [CanteenManagement] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [CanteenManagement] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [CanteenManagement] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [CanteenManagement] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [CanteenManagement] SET ARITHABORT OFF 
GO
ALTER DATABASE [CanteenManagement] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [CanteenManagement] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [CanteenManagement] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [CanteenManagement] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [CanteenManagement] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [CanteenManagement] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [CanteenManagement] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [CanteenManagement] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [CanteenManagement] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [CanteenManagement] SET  ENABLE_BROKER 
GO
ALTER DATABASE [CanteenManagement] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [CanteenManagement] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [CanteenManagement] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [CanteenManagement] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [CanteenManagement] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [CanteenManagement] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [CanteenManagement] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [CanteenManagement] SET RECOVERY FULL 
GO
ALTER DATABASE [CanteenManagement] SET  MULTI_USER 
GO
ALTER DATABASE [CanteenManagement] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [CanteenManagement] SET DB_CHAINING OFF 
GO
ALTER DATABASE [CanteenManagement] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [CanteenManagement] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [CanteenManagement] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'CanteenManagement', N'ON'
GO
USE [CanteenManagement]
GO
/****** Object:  UserDefinedFunction [dbo].[CalculateOrderID]    Script Date: 4/28/2021 3:27:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[CalculateOrderID](@order_id int)
returns money
as
begin
	declare @ans money
	select @ans = sum(num_of_food * cur_price) from OrderDetail where order_id = @order_id
	declare @customer_id varchar(15)
	select @customer_id = customer_id from CustomerOrder where @order_id = id
	declare @type nvarchar(3)
	select @type = VIP from Customer where id = @customer_id
	if (@type like 'YES')
		set @ans = @ans *0.95
	return @ans
end


GO
/****** Object:  Table [dbo].[Customer]    Script Date: 4/28/2021 3:27:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Customer](
	[id] [varchar](15) NOT NULL,
	[VIP] [varchar](3) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CustomerOrder]    Script Date: 4/28/2021 3:27:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CustomerOrder](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[order_time] [smalldatetime] NOT NULL,
	[status_now] [int] NULL,
	[staff_id] [varchar](15) NOT NULL,
	[address] [ntext] NULL,
	[customer_id] [varchar](15) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CustomerUser]    Script Date: 4/28/2021 3:27:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CustomerUser](
	[user_id] [varchar](20) NOT NULL,
	[password] [varchar](20) NOT NULL,
	[customer_id] [varchar](15) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Food]    Script Date: 4/28/2021 3:27:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Food](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[describe] [ntext] NULL,
	[price] [money] NOT NULL,
	[img] [text] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Menu]    Script Date: 4/28/2021 3:27:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Menu](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[time_start] [smalldatetime] NOT NULL,
	[time_end] [smalldatetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MenuDetail]    Script Date: 4/28/2021 3:27:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MenuDetail](
	[menu_id] [int] NOT NULL,
	[food_id] [int] NOT NULL,
 CONSTRAINT [PK_Menu] PRIMARY KEY CLUSTERED 
(
	[menu_id] ASC,
	[food_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OrderDetail]    Script Date: 4/28/2021 3:27:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDetail](
	[order_id] [int] NOT NULL,
	[food_id] [int] NOT NULL,
	[num_of_food] [int] NULL DEFAULT ((1)),
	[cur_price] [money] NULL,
 CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED 
(
	[order_id] ASC,
	[food_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Person]    Script Date: 4/28/2021 3:27:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Person](
	[id] [varchar](15) NOT NULL,
	[name] [nvarchar](30) NULL,
	[gender] [nvarchar](3) NULL,
	[identity_card] [nvarchar](10) NULL,
	[day_of_birth] [date] NULL,
	[phone_num] [nvarchar](10) NULL,
	[address] [nvarchar](300) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Role]    Script Date: 4/28/2021 3:27:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Role](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[role_name] [nvarchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Staff]    Script Date: 4/28/2021 3:27:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Staff](
	[id] [varchar](15) NOT NULL,
	[salary] [money] NULL,
 CONSTRAINT [PK__Staff__3213E83FBB15C9E0] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserLogin]    Script Date: 4/28/2021 3:27:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UserLogin](
	[user_id] [varchar](20) NOT NULL,
	[password] [varchar](20) NOT NULL,
	[role_id] [int] NOT NULL,
	[staff_id] [varchar](15) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  UserDefinedFunction [dbo].[StatsOrderRevenue]    Script Date: 4/28/2021 3:27:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[StatsOrderRevenue]()
returns table
as
	return select distinct order_id, dbo.CalculateOrderID(order_id) as Revenue from OrderDetail


GO
/****** Object:  UserDefinedFunction [dbo].[InfoOrder]    Script Date: 4/28/2021 3:27:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[InfoOrder]()
returns table
as
	return select * from dbo.StatsOrderRevenue(), CustomerOrder where order_id = CustomerOrder.id and status_now = 1
GO
/****** Object:  UserDefinedFunction [dbo].[StatsRevenueByMonth]    Script Date: 4/28/2021 3:27:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[StatsRevenueByMonth](@year int)
returns table
as
	return select CAST(YEAR(order_time) AS VARCHAR(4)) + '-' + CAST(MONTH(order_time) AS VARCHAR(2)) as year_month,
	sum(Revenue) as revenue from dbo.InfoOrder()
	group by CAST(YEAR(order_time) AS VARCHAR(4)) + '-' + CAST(MONTH(order_time) AS VARCHAR(2))
	having Year(convert(date, CAST(YEAR(order_time) AS VARCHAR(4)) + '-' + CAST(MONTH(order_time) AS VARCHAR(2)) + '-01')) = @year
GO
/****** Object:  UserDefinedFunction [dbo].[StatsRevenueByDay]    Script Date: 4/28/2021 3:27:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[StatsRevenueByDay](@day smalldatetime)
returns table
as
	return select CAST(year(order_time) AS VARCHAR(4)) + '-' + CAST(MONTH(order_time) AS VARCHAR(2)) + '-' + 
	CAST(day(order_time) AS VARCHAR(2)) as year_month_day,
	sum(Revenue) as revenue from dbo.InfoOrder()
	group by CAST(year(order_time) AS VARCHAR(4)) + '-' + CAST(MONTH(order_time) AS VARCHAR(2)) + '-' + 
	CAST(day(order_time) AS VARCHAR(2))
	having convert(date, CAST(year(order_time) AS VARCHAR(4)) + '-' + CAST(MONTH(order_time) AS VARCHAR(2)) + '-' + 
	CAST(day(order_time) AS VARCHAR(2))) = convert(date, @day)

GO
/****** Object:  UserDefinedFunction [dbo].[InfoAllOrder]    Script Date: 4/28/2021 3:27:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[InfoAllOrder]()
returns table
as
	return select * from dbo.StatsOrderRevenue(), CustomerOrder where order_id = CustomerOrder.id
GO
/****** Object:  UserDefinedFunction [dbo].[CountSuccessOrder]    Script Date: 4/28/2021 3:27:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[CountSuccessOrder](@day smalldatetime)
returns table
as
	return select CAST(year(order_time) AS VARCHAR(4)) + '-' + CAST(MONTH(order_time) AS VARCHAR(2)) + '-' + 
	CAST(day(order_time) AS VARCHAR(2)) as year_month_day,
	count(*) as revenue from dbo.InfoOrder()
	group by CAST(year(order_time) AS VARCHAR(4)) + '-' + CAST(MONTH(order_time) AS VARCHAR(2)) + '-' + 
	CAST(day(order_time) AS VARCHAR(2))
	having convert(date, CAST(year(order_time) AS VARCHAR(4)) + '-' + CAST(MONTH(order_time) AS VARCHAR(2)) + '-' + 
	CAST(day(order_time) AS VARCHAR(2))) = convert(date, @day)
GO
/****** Object:  UserDefinedFunction [dbo].[CountAllOrder]    Script Date: 4/28/2021 3:27:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[CountAllOrder](@day smalldatetime)
returns table
as
	return select CAST(year(order_time) AS VARCHAR(4)) + '-' + CAST(MONTH(order_time) AS VARCHAR(2)) + '-' + 
	CAST(day(order_time) AS VARCHAR(2)) as year_month_day,
	count(*) as revenue from dbo.InfoAllOrder()
	group by CAST(year(order_time) AS VARCHAR(4)) + '-' + CAST(MONTH(order_time) AS VARCHAR(2)) + '-' + 
	CAST(day(order_time) AS VARCHAR(2))
	having convert(date, CAST(year(order_time) AS VARCHAR(4)) + '-' + CAST(MONTH(order_time) AS VARCHAR(2)) + '-' + 
	CAST(day(order_time) AS VARCHAR(2))) = convert(date, @day)
GO
/****** Object:  UserDefinedFunction [dbo].[SelectAllInfoCustomer]    Script Date: 4/28/2021 3:27:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[SelectAllInfoCustomer]()
returns table
as return select Person.id, name, gender, identity_card, day_of_birth, phone_num, address, VIP, password 
from Person, CustomerUser, Customer
where Customer.id = CustomerUser.customer_id and Person.id = Customer.id



GO
/****** Object:  UserDefinedFunction [dbo].[SelectAllInfoStaff]    Script Date: 4/28/2021 3:27:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[SelectAllInfoStaff]()
returns table
as return select Person.id, name, gender, identity_card, day_of_birth, phone_num, address,
role_name, salary, password from Person, UserLogin, role, Staff 
where role.id = UserLogin.role_id and UserLogin.staff_id = Staff.id
and Person.id = Staff.id and role.id = UserLogin.role_id


GO
/****** Object:  UserDefinedFunction [dbo].[SelectInfoCustomerByID]    Script Date: 4/28/2021 3:27:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[SelectInfoCustomerByID](@customer_id varchar(15))
returns table
as return select Person.id, name, gender, identity_card, day_of_birth, phone_num, address, VIP, password 
from Person, CustomerUser, Customer
where Customer.id = CustomerUser.customer_id and Person.id = Customer.id and Person.id = @customer_id


GO
/****** Object:  UserDefinedFunction [dbo].[SelectInfoStaffByID]    Script Date: 4/28/2021 3:27:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[SelectInfoStaffByID](@staff_id varchar(15))
returns table
as return select Person.id, name, gender, identity_card, day_of_birth, phone_num, address,
role_name, salary, password from Person, UserLogin, role, Staff 
where role.id = UserLogin.role_id and UserLogin.staff_id = Staff.id
and Person.id = Staff.id and role.id = UserLogin.role_id and Person.id = @staff_id


GO
INSERT [dbo].[Customer] ([id], [VIP]) VALUES (N'KH001', N'yes')
INSERT [dbo].[Customer] ([id], [VIP]) VALUES (N'KH002', N'NO')
INSERT [dbo].[Customer] ([id], [VIP]) VALUES (N'KH003', N'NO')
INSERT [dbo].[Customer] ([id], [VIP]) VALUES (N'KH005', N'NO')
SET IDENTITY_INSERT [dbo].[CustomerOrder] ON 

INSERT [dbo].[CustomerOrder] ([id], [order_time], [status_now], [staff_id], [address], [customer_id]) VALUES (2, CAST(N'2020-05-05 11:00:00' AS SmallDateTime), 1, N'NV002', N'97 Man Thiện', N'KH001')
INSERT [dbo].[CustomerOrder] ([id], [order_time], [status_now], [staff_id], [address], [customer_id]) VALUES (4, CAST(N'2021-04-12 19:34:00' AS SmallDateTime), 1, N'NV002', N'Học viện Chính Trị cơ sở 2', N'KH005')
INSERT [dbo].[CustomerOrder] ([id], [order_time], [status_now], [staff_id], [address], [customer_id]) VALUES (5, CAST(N'2021-04-12 05:34:00' AS SmallDateTime), 1, N'NV003', NULL, NULL)
INSERT [dbo].[CustomerOrder] ([id], [order_time], [status_now], [staff_id], [address], [customer_id]) VALUES (6, CAST(N'2021-04-12 05:34:00' AS SmallDateTime), 3, N'NV003', NULL, NULL)
INSERT [dbo].[CustomerOrder] ([id], [order_time], [status_now], [staff_id], [address], [customer_id]) VALUES (7, CAST(N'2021-03-12 07:34:00' AS SmallDateTime), 0, N'NV002', NULL, NULL)
INSERT [dbo].[CustomerOrder] ([id], [order_time], [status_now], [staff_id], [address], [customer_id]) VALUES (11, CAST(N'2021-04-13 18:34:00' AS SmallDateTime), 2, N'NV002', NULL, NULL)
INSERT [dbo].[CustomerOrder] ([id], [order_time], [status_now], [staff_id], [address], [customer_id]) VALUES (12, CAST(N'2021-04-21 20:06:00' AS SmallDateTime), 0, N'NV002', N'104 Nguyễn Thị Minh Khai, quận 1', NULL)
SET IDENTITY_INSERT [dbo].[CustomerOrder] OFF
INSERT [dbo].[CustomerUser] ([user_id], [password], [customer_id]) VALUES (N'gamelade', N'gggTai1234', N'KH001')
INSERT [dbo].[CustomerUser] ([user_id], [password], [customer_id]) VALUES (N'mumumu', N'mumumu123A', N'KH005')
INSERT [dbo].[CustomerUser] ([user_id], [password], [customer_id]) VALUES (N'needgas', N'asd19ASSS', N'KH002')
INSERT [dbo].[CustomerUser] ([user_id], [password], [customer_id]) VALUES (N'simp_chua', N'vatBonS1mp', N'KH003')
SET IDENTITY_INSERT [dbo].[Food] ON 

INSERT [dbo].[Food] ([id], [name], [describe], [price], [img]) VALUES (1, N'Bánh canh', N'Bánh canh bao gồm nước dùng được nấu từ tôm, cá và giò heo thêm gia vị tùy theo từng loại bánh canh. Sợi bánh canh có thể được làm từ bột gạo, bột mì, bột năng hoặc bột sắn hoặc bột gạo pha bột sắn.', 25000.0000, N'banh_canh.jpg')
INSERT [dbo].[Food] ([id], [name], [describe], [price], [img]) VALUES (2, N'Bánh ướt lòng gà', N'Bánh ướt lòng gà bao gồm bánh ướt nóng hòa cùng lòng gà béo ngậy. Quyện thêm chút nước mắm chua ngọt mang lại hương vị hoàn hảo.', 20000.0000, N'banh_uot_long_ga.jpg')
INSERT [dbo].[Food] ([id], [name], [describe], [price], [img]) VALUES (3, N'Bánh xèo', N'Bánh xèo có nhân là tôm, thịt, giá đỗ; kim chi, khoai tây, hẹ,; tôm, thịt, cải thảo được rán màu vàng,đúc thành hình tròn hoặc gấp lại thành hình bán nguyệt.', 6000.0000, N'banh_xeo.jpg')
INSERT [dbo].[Food] ([id], [name], [describe], [price], [img]) VALUES (4, N'Bò xào đậu que', N'Bò xào đậu que có thịt bò mềm, đậu que ngọt giòn, sẽ giúp bữa cơm của bạn thêm nhiều dinh dưỡng và năng lượng để tiếp tục công việc.', 20000.0000, N'bo_xao_dau_que.jpg')
INSERT [dbo].[Food] ([id], [name], [describe], [price], [img]) VALUES (5, N'Bún Huế', N'Bún Huế có nguyên liệu chính là bún, thịt bắp bò, giò heo, cùng nước dùng có màu đỏ đặc trưng và vị sả và ruốc.', 30000.0000, N'bun_hue.jpg')
INSERT [dbo].[Food] ([id], [name], [describe], [price], [img]) VALUES (6, N'Bún Nem Nướng', N'Bún Nem Nướng có nem nướng nóng hổi, ăn kèm với bún tươi và rau sống siêu sạch sẽ thoải mãi vị giác của bạn.', 25000.0000, N'bun_nem_nuong.jpg')
INSERT [dbo].[Food] ([id], [name], [describe], [price], [img]) VALUES (7, N'Cá Kho Tộ', N'Cá Kho Tộ thơm ngon bổ dưỡng. Vị thơm của gừng, sả quyệt vào thịt cá thơm mềm khiến cho bữa cơm của bạn trở nên hoàn hảo', 22000.0000, N'ca_kho_to.jpg')
INSERT [dbo].[Food] ([id], [name], [describe], [price], [img]) VALUES (8, N'Cá Ngừ Kho Thơm', N'Cá Ngừ Kho Thơm được kho theo kiểu miền Trung, nước kho rất nhiều để ăn kèm với bún tươi và rau sống, ăn là ghiền.', 22000.0000, N'ca_ngu_kho_thom.jpg')
INSERT [dbo].[Food] ([id], [name], [describe], [price], [img]) VALUES (9, N'Cải thìa sốt dầu hào', N'Cải thìa sốt dầu hào thơm ngon, tươi mát sẽ là một sự lựa chọn tuyệt vời cho bữa cơm của bạn thêm phong phú.', 18000.0000, N'cai_thia_sot_dau_hao.jpg')
INSERT [dbo].[Food] ([id], [name], [describe], [price], [img]) VALUES (10, N'Canh chua cá lóc', N'Canh chua cá lóc là món ăn giàu dinh dưỡng, theo Y học, cá lóc có tính bình không độc, tác dụng trừ phong thấp, chữa trĩ, rất bổ ích.', 27000.0000, N'canh_chua_ca_loc.jpg')
INSERT [dbo].[Food] ([id], [name], [describe], [price], [img]) VALUES (11, N'Canh khổ qua nhồi thịt', N'Canh khổ qua nhồi thịt giúp thanh mát, giúp giảm cân, thanh nhiệt cơ thể, giải nhiệt cuộc sống.', 27000.0000, N'canh_kho_qua_nhoi_thit.jpg')
INSERT [dbo].[Food] ([id], [name], [describe], [price], [img]) VALUES (12, N'Cơm chiên', N'Cơm chiên được chế biến trong chảo hoặc chảo rán và thường được trộn với các thành phần khác như trứng, rau, hải sản hoặc thịt.', 25000.0000, N'com_chien.png')
INSERT [dbo].[Food] ([id], [name], [describe], [price], [img]) VALUES (13, N'Đậu hủ kho nấm', N'Đậu hủ kho nấm đầy bổ dưỡng và đặc biệt vô cùng thơm ngon, đây là một trong những lựa chọn hoàn hảo cho thực đơn chay, giảm cân.', 15000.0000, N'dau_hu_kho_nam.jpg')
INSERT [dbo].[Food] ([id], [name], [describe], [price], [img]) VALUES (14, N'Đậu hủ sốt cà chua', N'Đậu hủ sốt cà chua là món ăn chay ngon, thanh đạm với giá rẻ nhưng cũng không kém phần ngon miệng.', 15000.0000, N'dau_sot_ca_chua.jpg')
INSERT [dbo].[Food] ([id], [name], [describe], [price], [img]) VALUES (15, N'Ếch xào xả ớt', N'Ếch xào xả ớt là món ngon đậm đà, hương vị thì ngon không cưỡng nổi. Món ăn với vị cay thơm đặc trưng của sả, ớt quyện với thịt ếch xào chín dai ngon tròn vị thích hợp ngày mưa, mát lạnh.', 22000.0000, N'ech_xao_xa_ot.jpg')
INSERT [dbo].[Food] ([id], [name], [describe], [price], [img]) VALUES (16, N'Gà chiên nước mắm', N'Gà chiên nước mắm là món ăn yêu thích đối với tất cả mọi người. Vị cay cay, giòn giòn, quyện gia vị hoàn hảo từ món ăn sẽ mang sức hút khó cưỡng cho bạn', 20000.0000, N'ga_chien_nuoc_mam.jpg')
INSERT [dbo].[Food] ([id], [name], [describe], [price], [img]) VALUES (17, N'Gà kho', N'Gà kho là món ăn chế biến đơn giản. Vị ngọt của gà, vị ấm nồng của nhánh gừng cay cay chắc chắn sẽ khiến cho bạn không thể nào quên.', 20000.0000, N'ga_kho.jpg')
INSERT [dbo].[Food] ([id], [name], [describe], [price], [img]) VALUES (18, N'Hủ tiếu', N'Hủ tiếu  là món ăn đặc trưng của người Nam Bộ. Món ăn cực kì hấp dẫn này sẽ thoải mãi cơn đói của bạn ngay tức thì.', 25000.0000, N'hu_tieu.jpg')
INSERT [dbo].[Food] ([id], [name], [describe], [price], [img]) VALUES (19, N'Măng xào thịt', N'Măng xào thịt là món ăn từ những nguyên liệu quen thuộc, món ăn này sẽ đem lại hương vị thơm ngon đậm đà, ăn kèm với cơm nóng thì ngon hết sảy luôn nhé.', 22000.0000, N'mang_xao_thit.jpg')
INSERT [dbo].[Food] ([id], [name], [describe], [price], [img]) VALUES (20, N'Mì quảng', N'Mì quảng à một món ăn đặc sản đặc trưng của Quảng Nam và Đà Nẵng, Việt Nam. Mì Quảng thường được làm từ bột gạo xay mịn lẫn nước từ hạt dành dành và trứng.', 25000.0000, N'mi_quang.jpg')
INSERT [dbo].[Food] ([id], [name], [describe], [price], [img]) VALUES (21, N'Mực xào', N'Mực xào là một trong những món được chế biến từ mực ngon, hấp dẫn cung cấp nhiều dưỡng chất tốt cho sức khỏe.', 35000.0000, N'muc-xao.jpg')
INSERT [dbo].[Food] ([id], [name], [describe], [price], [img]) VALUES (22, N'Phở bò', N'Phở bò là món ăn với hương thơm đặc trưng của thịt bò hòa quyện cùng nước dùng thanh ngọt, sợi phở mềm dai cực kỳ hấp dẫn vị giác.', 30000.0000, N'pho_bo.jpg')
INSERT [dbo].[Food] ([id], [name], [describe], [price], [img]) VALUES (23, N'Rau luộc kho quẹt', N'Rau luộc kho quẹt là món ăn dân dã của người dân Nam bộ. Món ăn khơi gợi mùi vị nước mắm đật chất vùng miền.', 20000.0000, N'rau_luoc_kho_quet.jpg')
INSERT [dbo].[Food] ([id], [name], [describe], [price], [img]) VALUES (24, N'Rau ngót bò băm ', N'Rau ngót bò băm có vị thơm đặc trưng của rau ngót, ngọt mềm của thịt. Mang lại cảm giác tươi mát cho mùa nóng bức.', 22000.0000, N'rau_ngot_bo_bam.jpg')
INSERT [dbo].[Food] ([id], [name], [describe], [price], [img]) VALUES (25, N'Sườn nướng ', N'Sườn nướng bằng sườn heo và hay dùng với cơm tấm chan mỡ hành ăn cùng với cà chua, đồ chua và dưa leo sẽ tiếp thêm đầy đủ năng lượng cho bạn chiến đấu cả ngày.', 25000.0000, N'suon_nuong.jpg')
INSERT [dbo].[Food] ([id], [name], [describe], [price], [img]) VALUES (26, N'Sườn xào chua ngọt', N'Sườn xào chua ngọt với vị thơm ngon, thịt sườn mềm ngấm đều gia vị chua chua, ngọt ngọt rất đưa cơm trong ngày lạnh.', 25000.0000, N'suon_xao_chua_ngot.jpg')
INSERT [dbo].[Food] ([id], [name], [describe], [price], [img]) VALUES (27, N'Thịt kho tàu', N'Thịt kho tàu là món ăn quen thuộc của người Việt Nam, đặc biệt là người miền Bắc. Món ăn với hương vị đậm đà, trứng bùi bùi và thịt mềm ngon bá cháy sẽ thoải mãi bạn.', 22000.0000, N'thit_kho_tau.jpg')
INSERT [dbo].[Food] ([id], [name], [describe], [price], [img]) VALUES (28, N'Thịt luộc', N'Thịt luộc được luộc mềm, ngon, không hôi hoàn quyện nước mắm sẽ rất tuyệt vời cho bữa ăn của bạn. Thịt luộc là chân ái', 22000.0000, N'thit_luoc.jpg')
INSERT [dbo].[Food] ([id], [name], [describe], [price], [img]) VALUES (29, N'Tôm rang muối', N'Tôm rang muối ngon, vàng giòn, cay cay sẽ đưa bạn lên nấc thang thiên đường trong những ngày buốt giá.', 35000.0000, N'tom_rang_muoi.jpg')
INSERT [dbo].[Food] ([id], [name], [describe], [price], [img]) VALUES (30, N'Trứng chiên', N'Trứng chiên là món ăn quen thuộc với tất cả mọi người. Trứng được chiên vừa chín, giòn hòa đậm hương vị sẽ tiếp thêm đầy đủ năng lượng cho bạn.', 20000.0000, N'trung_chien.jpg')
SET IDENTITY_INSERT [dbo].[Food] OFF
SET IDENTITY_INSERT [dbo].[Menu] ON 

INSERT [dbo].[Menu] ([id], [time_start], [time_end]) VALUES (1, CAST(N'2021-04-12 16:00:00' AS SmallDateTime), CAST(N'2021-04-12 21:00:00' AS SmallDateTime))
INSERT [dbo].[Menu] ([id], [time_start], [time_end]) VALUES (2, CAST(N'2021-03-12 05:00:00' AS SmallDateTime), CAST(N'2021-03-12 09:59:00' AS SmallDateTime))
INSERT [dbo].[Menu] ([id], [time_start], [time_end]) VALUES (4, CAST(N'2020-05-05 10:00:00' AS SmallDateTime), CAST(N'2020-05-05 15:59:00' AS SmallDateTime))
INSERT [dbo].[Menu] ([id], [time_start], [time_end]) VALUES (5, CAST(N'2021-04-12 05:00:00' AS SmallDateTime), CAST(N'2021-04-12 09:59:00' AS SmallDateTime))
SET IDENTITY_INSERT [dbo].[Menu] OFF
INSERT [dbo].[MenuDetail] ([menu_id], [food_id]) VALUES (1, 1)
INSERT [dbo].[MenuDetail] ([menu_id], [food_id]) VALUES (1, 2)
INSERT [dbo].[MenuDetail] ([menu_id], [food_id]) VALUES (1, 3)
INSERT [dbo].[MenuDetail] ([menu_id], [food_id]) VALUES (1, 4)
INSERT [dbo].[MenuDetail] ([menu_id], [food_id]) VALUES (1, 5)
INSERT [dbo].[MenuDetail] ([menu_id], [food_id]) VALUES (2, 6)
INSERT [dbo].[MenuDetail] ([menu_id], [food_id]) VALUES (2, 7)
INSERT [dbo].[MenuDetail] ([menu_id], [food_id]) VALUES (2, 8)
INSERT [dbo].[MenuDetail] ([menu_id], [food_id]) VALUES (2, 9)
INSERT [dbo].[MenuDetail] ([menu_id], [food_id]) VALUES (2, 10)
INSERT [dbo].[MenuDetail] ([menu_id], [food_id]) VALUES (2, 11)
INSERT [dbo].[MenuDetail] ([menu_id], [food_id]) VALUES (2, 12)
INSERT [dbo].[MenuDetail] ([menu_id], [food_id]) VALUES (2, 13)
INSERT [dbo].[MenuDetail] ([menu_id], [food_id]) VALUES (2, 14)
INSERT [dbo].[MenuDetail] ([menu_id], [food_id]) VALUES (4, 3)
INSERT [dbo].[MenuDetail] ([menu_id], [food_id]) VALUES (4, 4)
INSERT [dbo].[MenuDetail] ([menu_id], [food_id]) VALUES (4, 5)
INSERT [dbo].[MenuDetail] ([menu_id], [food_id]) VALUES (4, 6)
INSERT [dbo].[MenuDetail] ([menu_id], [food_id]) VALUES (4, 7)
INSERT [dbo].[MenuDetail] ([menu_id], [food_id]) VALUES (5, 20)
INSERT [dbo].[MenuDetail] ([menu_id], [food_id]) VALUES (5, 22)
INSERT [dbo].[MenuDetail] ([menu_id], [food_id]) VALUES (5, 24)
INSERT [dbo].[MenuDetail] ([menu_id], [food_id]) VALUES (5, 26)
INSERT [dbo].[MenuDetail] ([menu_id], [food_id]) VALUES (5, 28)
INSERT [dbo].[OrderDetail] ([order_id], [food_id], [num_of_food], [cur_price]) VALUES (2, 2, 1, 50000.0000)
INSERT [dbo].[OrderDetail] ([order_id], [food_id], [num_of_food], [cur_price]) VALUES (2, 3, 5, 15000.0000)
INSERT [dbo].[OrderDetail] ([order_id], [food_id], [num_of_food], [cur_price]) VALUES (2, 4, 7, 3000.0000)
INSERT [dbo].[OrderDetail] ([order_id], [food_id], [num_of_food], [cur_price]) VALUES (4, 4, 2, 9000.0000)
INSERT [dbo].[OrderDetail] ([order_id], [food_id], [num_of_food], [cur_price]) VALUES (4, 7, 2, 60000.0000)
INSERT [dbo].[OrderDetail] ([order_id], [food_id], [num_of_food], [cur_price]) VALUES (5, 20, 3, 25000.0000)
INSERT [dbo].[OrderDetail] ([order_id], [food_id], [num_of_food], [cur_price]) VALUES (5, 24, 2, 22000.0000)
INSERT [dbo].[OrderDetail] ([order_id], [food_id], [num_of_food], [cur_price]) VALUES (5, 26, 6, 25000.0000)
INSERT [dbo].[OrderDetail] ([order_id], [food_id], [num_of_food], [cur_price]) VALUES (6, 24, 10, 22000.0000)
INSERT [dbo].[OrderDetail] ([order_id], [food_id], [num_of_food], [cur_price]) VALUES (6, 26, 4, 25000.0000)
INSERT [dbo].[OrderDetail] ([order_id], [food_id], [num_of_food], [cur_price]) VALUES (6, 28, 7, 22000.0000)
INSERT [dbo].[OrderDetail] ([order_id], [food_id], [num_of_food], [cur_price]) VALUES (7, 13, 6, 15000.0000)
INSERT [dbo].[Person] ([id], [name], [gender], [identity_card], [day_of_birth], [phone_num], [address]) VALUES (N'KH001', N'Nguyễn Lê Tấn Tài', N'Nam', N'198738192', CAST(N'2000-06-15' AS Date), N'0918231231', N'Quận 7')
INSERT [dbo].[Person] ([id], [name], [gender], [identity_card], [day_of_birth], [phone_num], [address]) VALUES (N'KH002', N'Cao Thành Lợi', N'Nam', N'1231122223', CAST(N'2000-05-23' AS Date), N'0911009922', N'Huyện Bình Chánh')
INSERT [dbo].[Person] ([id], [name], [gender], [identity_card], [day_of_birth], [phone_num], [address]) VALUES (N'KH003', N'Nguyễn Thanh Hiền', N'Nam', N'123999999', CAST(N'2000-04-13' AS Date), N'0909123456', N'Quận 9')
INSERT [dbo].[Person] ([id], [name], [gender], [identity_card], [day_of_birth], [phone_num], [address]) VALUES (N'KH005', N'Nguyễn Quốc Thắng', N'Nam', N'123123123', CAST(N'2000-05-03' AS Date), N'0987654432', N'Quận 9')
INSERT [dbo].[Person] ([id], [name], [gender], [identity_card], [day_of_birth], [phone_num], [address]) VALUES (N'KH008', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Person] ([id], [name], [gender], [identity_card], [day_of_birth], [phone_num], [address]) VALUES (N'NV00', N'Lãnh tụ tối cao', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Person] ([id], [name], [gender], [identity_card], [day_of_birth], [phone_num], [address]) VALUES (N'NV002', N'Nguyễn Đình Trung', N'Nam', N'198299328', CAST(N'2000-03-21' AS Date), N'0987287187', N'Thành phố Thủ Đức')
INSERT [dbo].[Person] ([id], [name], [gender], [identity_card], [day_of_birth], [phone_num], [address]) VALUES (N'NV003', N'Trần Thị Ngọc Châu', N'Nữ', N'191109328', CAST(N'2000-06-12' AS Date), N'0917287177', N'Quận 8')
INSERT [dbo].[Person] ([id], [name], [gender], [identity_card], [day_of_birth], [phone_num], [address]) VALUES (N'NV005', NULL, NULL, NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[Role] ON 

INSERT [dbo].[Role] ([id], [role_name]) VALUES (1, N'Quản lý')
INSERT [dbo].[Role] ([id], [role_name]) VALUES (2, N'Thu ngân')
INSERT [dbo].[Role] ([id], [role_name]) VALUES (3, N'Phục vụ bàn')
INSERT [dbo].[Role] ([id], [role_name]) VALUES (4, N'Nhân viên giao hàng')
INSERT [dbo].[Role] ([id], [role_name]) VALUES (5, N'Phục vụ bàn')
INSERT [dbo].[Role] ([id], [role_name]) VALUES (6, N'Nhân viên vệ sinh')
SET IDENTITY_INSERT [dbo].[Role] OFF
INSERT [dbo].[Staff] ([id], [salary]) VALUES (N'NV00', NULL)
INSERT [dbo].[Staff] ([id], [salary]) VALUES (N'NV002', 30000000.0000)
INSERT [dbo].[Staff] ([id], [salary]) VALUES (N'NV003', 1500000.0000)
INSERT [dbo].[UserLogin] ([user_id], [password], [role_id], [staff_id]) VALUES (N'admin', N'doAnhBatDuocEm1', 1, N'NV00')
INSERT [dbo].[UserLogin] ([user_id], [password], [role_id], [staff_id]) VALUES (N'Taideeptry2', N'conAiDepTraiHonTai1', 5, N'NV002')
INSERT [dbo].[UserLogin] ([user_id], [password], [role_id], [staff_id]) VALUES (N'Taiprosieucapvutru', N'abcd', 2, N'NV003')
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__UserLogi__1963DD9DDABFE70A]    Script Date: 4/28/2021 3:27:39 PM ******/
ALTER TABLE [dbo].[UserLogin] ADD UNIQUE NONCLUSTERED 
(
	[staff_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD  CONSTRAINT [FK_Customer] FOREIGN KEY([id])
REFERENCES [dbo].[Person] ([id])
GO
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [FK_Customer]
GO
ALTER TABLE [dbo].[CustomerOrder]  WITH CHECK ADD  CONSTRAINT [FK_Cus] FOREIGN KEY([staff_id])
REFERENCES [dbo].[Staff] ([id])
GO
ALTER TABLE [dbo].[CustomerOrder] CHECK CONSTRAINT [FK_Cus]
GO
ALTER TABLE [dbo].[CustomerOrder]  WITH CHECK ADD  CONSTRAINT [FK_Customer_Order] FOREIGN KEY([customer_id])
REFERENCES [dbo].[Customer] ([id])
GO
ALTER TABLE [dbo].[CustomerOrder] CHECK CONSTRAINT [FK_Customer_Order]
GO
ALTER TABLE [dbo].[CustomerUser]  WITH CHECK ADD  CONSTRAINT [FK_User_Customer] FOREIGN KEY([customer_id])
REFERENCES [dbo].[Customer] ([id])
GO
ALTER TABLE [dbo].[CustomerUser] CHECK CONSTRAINT [FK_User_Customer]
GO
ALTER TABLE [dbo].[MenuDetail]  WITH CHECK ADD  CONSTRAINT [FK_Menu_Food] FOREIGN KEY([food_id])
REFERENCES [dbo].[Food] ([id])
GO
ALTER TABLE [dbo].[MenuDetail] CHECK CONSTRAINT [FK_Menu_Food]
GO
ALTER TABLE [dbo].[MenuDetail]  WITH CHECK ADD  CONSTRAINT [FK_Menu_Id] FOREIGN KEY([menu_id])
REFERENCES [dbo].[Menu] ([id])
GO
ALTER TABLE [dbo].[MenuDetail] CHECK CONSTRAINT [FK_Menu_Id]
GO
ALTER TABLE [dbo].[OrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_Order_Food] FOREIGN KEY([food_id])
REFERENCES [dbo].[Food] ([id])
GO
ALTER TABLE [dbo].[OrderDetail] CHECK CONSTRAINT [FK_Order_Food]
GO
ALTER TABLE [dbo].[OrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_Order_Id] FOREIGN KEY([order_id])
REFERENCES [dbo].[CustomerOrder] ([id])
GO
ALTER TABLE [dbo].[OrderDetail] CHECK CONSTRAINT [FK_Order_Id]
GO
ALTER TABLE [dbo].[Staff]  WITH CHECK ADD  CONSTRAINT [FK_Staff] FOREIGN KEY([id])
REFERENCES [dbo].[Person] ([id])
GO
ALTER TABLE [dbo].[Staff] CHECK CONSTRAINT [FK_Staff]
GO
ALTER TABLE [dbo].[UserLogin]  WITH CHECK ADD  CONSTRAINT [FK_User_Role] FOREIGN KEY([role_id])
REFERENCES [dbo].[Role] ([id])
GO
ALTER TABLE [dbo].[UserLogin] CHECK CONSTRAINT [FK_User_Role]
GO
ALTER TABLE [dbo].[UserLogin]  WITH CHECK ADD  CONSTRAINT [FK_User_Staff] FOREIGN KEY([staff_id])
REFERENCES [dbo].[Staff] ([id])
GO
ALTER TABLE [dbo].[UserLogin] CHECK CONSTRAINT [FK_User_Staff]
GO
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD CHECK  (([VIP]='NO' OR [VIP]='YES'))
GO
ALTER TABLE [dbo].[CustomerOrder]  WITH CHECK ADD  CONSTRAINT [CK__CustomerO__statu__34C8D9D1] CHECK  (([status_now]=(1) OR [status_now]=(0) OR [status_now]=(2) OR [status_now]=(3)))
GO
ALTER TABLE [dbo].[CustomerOrder] CHECK CONSTRAINT [CK__CustomerO__statu__34C8D9D1]
GO
ALTER TABLE [dbo].[Food]  WITH CHECK ADD  CONSTRAINT [CheckPositiveFoodPrice] CHECK  (([price]>(0)))
GO
ALTER TABLE [dbo].[Food] CHECK CONSTRAINT [CheckPositiveFoodPrice]
GO
ALTER TABLE [dbo].[OrderDetail]  WITH CHECK ADD  CONSTRAINT [CheckPositiveNumFood] CHECK  (([num_of_food]>(0)))
GO
ALTER TABLE [dbo].[OrderDetail] CHECK CONSTRAINT [CheckPositiveNumFood]
GO
ALTER TABLE [dbo].[OrderDetail]  WITH CHECK ADD  CONSTRAINT [CheckPositiveOrderPrice] CHECK  (([cur_price]>(0)))
GO
ALTER TABLE [dbo].[OrderDetail] CHECK CONSTRAINT [CheckPositiveOrderPrice]
GO
ALTER TABLE [dbo].[Person]  WITH CHECK ADD CHECK  (([gender]=N'Nữ' OR [gender]=N'Nam'))
GO
ALTER TABLE [dbo].[Staff]  WITH CHECK ADD  CONSTRAINT [CheckPositiveSalary] CHECK  (([salary]>(0)))
GO
ALTER TABLE [dbo].[Staff] CHECK CONSTRAINT [CheckPositiveSalary]
GO
USE [master]
GO
ALTER DATABASE [CanteenManagement] SET  READ_WRITE 
GO
