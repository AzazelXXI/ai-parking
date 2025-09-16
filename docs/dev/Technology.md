# Công nghệ sử dụng trong dự án AI Parking

Tài liệu này mô tả chi tiết các công nghệ được sử dụng trong dự án AI Parking, cùng với lý do chọn lựa và các ưu điểm của từng công nghệ.

## 1. Frontend (Mobile App)

### 1.1. Flutter

- **Phiên bản**: Flutter 3.16+ (hoặc phiên bản mới nhất tại thời điểm phát triển)
- **Ngôn ngữ**: Dart 3.0+
- **Lý do chọn**:
  - Phát triển đa nền tảng (Android, iOS) từ một codebase duy nhất
  - Hiệu suất cao, gần như native
  - Hot reload giúp tăng tốc quá trình phát triển
  - UI mượt mà với tần số khung hình cao (60fps)
  - Cộng đồng lớn và hệ sinh thái package phong phú
- **Thư viện chính**:
  - **flutter_bloc**: Quản lý state theo mô hình BLoC
  - **dio**: HTTP client cho API calls
  - **get_it**: Dependency injection
  - **hive**: Database NoSQL trên thiết bị
  - **sqflite**: SQLite cho lưu trữ offline
  - **camera**: Truy cập camera thiết bị để nhận diện biển số
  - **flutter_nfc_reader**: Đọc thẻ NFC
  - **flutter_local_notifications**: Thông báo cục bộ
  - **google_maps_flutter**: Tích hợp bản đồ
  - **flutter_secure_storage**: Lưu trữ dữ liệu nhạy cảm (token, credentials)

### 1.2. AI Offline

- **Framework**: TensorFlow Lite / ML Kit
- **Mô hình**: MobileNet / EfficientDet (cho object detection)
- **Lý do chọn**:
  - Hoạt động không cần kết nối internet
  - Đảm bảo quyền riêng tư của dữ liệu
  - Giảm độ trễ trong xử lý
  - Tiết kiệm băng thông và chi phí server
- **Các tính năng AI offline**:
  - Nhận diện biển số xe
  - Phân loại loại xe
  - Đếm số xe trong bãi đỗ thông qua camera

### 1.3. Local Storage

- **SQLite**: Cơ sở dữ liệu quan hệ nhẹ
  - Lưu thông tin lịch sử đỗ xe
  - Lưu bảng giá và cấu hình bãi đỗ
  - Đảm bảo ACID cho giao dịch tài chính
- **Hive/SharedPreferences**: Lưu trữ key-value
  - Cài đặt ứng dụng
  - Dữ liệu cache
  - Trạng thái đăng nhập

## 2. Backend

### 2.1. FastAPI

- **Phiên bản**: FastAPI 0.100.0+
- **Ngôn ngữ**: Python 3.10+
- **Lý do chọn**:
  - Hiệu suất cao (nhanh ngang với Node.js và Go)
  - Tự động tạo tài liệu API (Swagger/OpenAPI)
  - Hỗ trợ async/await, tối ưu cho I/O bound operations
  - Type hints và validation tích hợp
  - Dễ dàng phát triển và bảo trì
- **Thư viện chính**:
  - **SQLAlchemy**: ORM cho cơ sở dữ liệu
  - **Pydantic**: Data validation và serialization
  - **Alembic**: Database migrations
  - **PyJWT**: Xác thực JWT
  - **passlib**: Băm mật khẩu
  - **celery**: Xử lý tác vụ bất đồng bộ
  - **pytest**: Testing framework

### 2.2. Cơ sở dữ liệu

#### 2.2.1. PostgreSQL

- **Phiên bản**: 14.0+
- **Lý do chọn**:
  - Cơ sở dữ liệu quan hệ mạnh mẽ, đáng tin cậy
  - Hỗ trợ JSON/JSONB cho dữ liệu bán cấu trúc
  - Tích hợp full-text search
  - Khả năng mở rộng tốt
  - Hỗ trợ GIS cho các tính năng địa lý
- **Dữ liệu lưu trữ**:
  - Thông tin người dùng, xe, bãi đỗ
  - Lịch sử đỗ xe
  - Giao dịch thanh toán
  - Cấu hình bãi đỗ và bảng giá

#### 2.2.2. Redis

- **Phiên bản**: 6.0+
- **Lý do chọn**:
  - Cache in-memory tốc độ cao
  - Hỗ trợ pub/sub cho real-time updates
  - Cấu trúc dữ liệu phong phú (string, hash, list, set, sorted set)
  - Hỗ trợ expiration (TTL) cho dữ liệu tạm thời
- **Dữ liệu lưu trữ**:
  - Trạng thái bãi đỗ xe theo thời gian thực
  - Cache API response
  - Quản lý phiên và rate limiting
  - Hàng đợi cho xử lý bất đồng bộ

#### 2.2.3. MongoDB

- **Phiên bản**: 5.0+
- **Lý do chọn**:
  - Cơ sở dữ liệu NoSQL linh hoạt cho dữ liệu bán cấu trúc
  - Hiệu suất cao cho hoạt động đọc
  - Mở rộng theo chiều ngang dễ dàng
  - Hỗ trợ aggregation pipeline cho phân tích
- **Dữ liệu lưu trữ**:
  - Logs hệ thống
  - Dữ liệu phân tích và báo cáo
  - Dữ liệu cảm biến và IoT
  - Dữ liệu AI training

### 2.3. AI và Machine Learning

#### 2.3.1. TensorFlow / PyTorch

- **Phiên bản**: TensorFlow 2.12+ / PyTorch 2.0+
- **Lý do chọn**:
  - Framework AI mạnh mẽ, linh hoạt
  - Hỗ trợ nhiều kiến trúc mô hình
  - Tích hợp tốt với Python và hệ sinh thái khoa học dữ liệu
  - Hỗ trợ GPU/TPU để tăng tốc training
- **Ứng dụng**:
  - Nhận diện biển số xe (ANPR)
  - Dự báo nhu cầu đỗ xe
  - Phân tích hành vi người dùng
  - Tối ưu hóa giá đỗ xe

#### 2.3.2. OpenCV

- **Phiên bản**: 4.8+
- **Lý do chọn**:
  - Thư viện xử lý ảnh và thị giác máy tính mạnh mẽ
  - Hiệu suất cao với các thuật toán tối ưu
  - Tích hợp tốt với TensorFlow/PyTorch
- **Ứng dụng**:
  - Tiền xử lý ảnh cho nhận diện biển số
  - Theo dõi chuyển động xe
  - Phát hiện không gian đỗ xe

### 2.4. Messaging & Streaming

#### 2.4.1. Kafka / RabbitMQ

- **Phiên bản**: Kafka 3.0+ / RabbitMQ 3.9+
- **Lý do chọn**:
  - Xử lý luồng dữ liệu lớn, real-time
  - Kiến trúc pub-sub đáng tin cậy
  - Khả năng mở rộng cao
  - Hỗ trợ persistency để không mất dữ liệu
- **Ứng dụng**:
  - Đồng bộ hóa dữ liệu giữa các microservice
  - Xử lý sự kiện xe vào/ra
  - Cập nhật trạng thái bãi đỗ theo thời gian thực
  - Xử lý logs và analytics

#### 2.4.2. WebSockets

- **Thư viện**: FastAPI WebSockets / Socket.IO
- **Lý do chọn**:
  - Kết nối hai chiều theo thời gian thực
  - Độ trễ thấp
  - Hỗ trợ các trình duyệt và nền tảng hiện đại
- **Ứng dụng**:
  - Cập nhật trạng thái bãi đỗ theo thời gian thực
  - Thông báo xe vào/ra
  - Dashboard theo dõi trực tuyến

## 3. DevOps & Deployment

### 3.1. Containerization

#### 3.1.1. Docker

- **Phiên bản**: 24.0+
- **Lý do chọn**:
  - Đóng gói ứng dụng và dependencies thành một đơn vị nhất quán
  - Môi trường phát triển, kiểm thử và sản xuất đồng nhất
  - Tăng tốc quá trình triển khai
  - Dễ dàng mở rộng và cập nhật

#### 3.1.2. Kubernetes

- **Phiên bản**: 1.25+
- **Lý do chọn**:
  - Điều phối container tự động
  - Khả năng mở rộng và tự phục hồi
  - Cân bằng tải và service discovery tích hợp
  - Rolling updates và rollbacks dễ dàng
- **Thành phần**:
  - **Helm**: Quản lý các gói Kubernetes
  - **Istio**: Service mesh cho bảo mật và giám sát
  - **Prometheus/Grafana**: Giám sát và visualization

### 3.2. CI/CD

#### 3.2.1. GitHub Actions / GitLab CI

- **Lý do chọn**:
  - Tích hợp chặt chẽ với repository
  - Tự động hóa build, test, và deployment
  - Cấu hình linh hoạt bằng YAML
  - Hỗ trợ nhiều environment và triggers
- **Pipeline stages**:
  - Lint và format code
  - Unit tests và integration tests
  - Build Docker images
  - Deploy to development/staging/production
  - E2E tests sau deployment

### 3.3. Monitoring & Logging

#### 3.3.1. Prometheus & Grafana

- **Phiên bản**: Prometheus 2.40+, Grafana 9.0+
- **Lý do chọn**:
  - Hệ thống giám sát mạnh mẽ, mở
  - Time-series database hiệu suất cao
  - Alerting linh hoạt
  - Visualizations đẹp và tùy biến
- **Metrics**:
  - API response time
  - Error rates
  - Database performance
  - System resources (CPU, memory, disk, network)
  - Business metrics (số lượt đỗ xe, doanh thu, etc.)

#### 3.3.2. ELK Stack / Loki

- **Phiên bản**: Elasticsearch 8.0+, Logstash 8.0+, Kibana 8.0+
- **Lý do chọn**:
  - Thu thập, lưu trữ và phân tích logs hiệu quả
  - Full-text search và aggregation mạnh mẽ
  - Visualization trực quan
  - Khả năng mở rộng tốt
- **Logs**:
  - Application logs
  - System logs
  - Access logs
  - Error logs
  - Security logs

## 4. Bảo mật

### 4.1. Authentication & Authorization

#### 4.1.1. JWT (JSON Web Tokens)

- **Thư viện**: PyJWT
- **Lý do chọn**:
  - Stateless authentication
  - Dễ dàng scale
  - Bảo mật với chữ ký số
  - Hỗ trợ claims và metadata
- **Ứng dụng**:
  - Xác thực người dùng
  - API authorization
  - Quản lý phiên
  - Single Sign-On (SSO)

#### 4.1.2. OAuth2 / OpenID Connect

- **Thư viện**: FastAPI's OAuth2 implementation
- **Lý do chọn**:
  - Chuẩn công nghiệp cho authorization
  - Hỗ trợ nhiều flow authentication
  - Tích hợp với nhiều identity providers
  - Bảo mật và linh hoạt
- **Ứng dụng**:
  - Social login (Google, Facebook, etc.)
  - B2B integration
  - API access management

### 4.2. Encryption & Data Protection

#### 4.2.1. HTTPS/TLS

- **Phiên bản**: TLS 1.3
- **Lý do chọn**:
  - Mã hóa dữ liệu trên đường truyền
  - Xác thực server
  - Bảo vệ chống man-in-the-middle attacks
  - Tuân thủ các tiêu chuẩn bảo mật hiện đại

#### 4.2.2. Database Encryption

- **Công nghệ**: PostgreSQL column encryption, TDE
- **Lý do chọn**:
  - Bảo vệ dữ liệu nhạy cảm tại rest
  - Tuân thủ các quy định về bảo vệ dữ liệu (GDPR, CCPA, etc.)
  - Giảm thiểu tác động của data breaches

## 5. External Services

### 5.1. Google Maps Platform

- **APIs**:
  - Maps SDK for Flutter
  - Maps JavaScript API
  - Directions API
  - Distance Matrix API
  - Geocoding API
- **Lý do chọn**:
  - Dữ liệu bản đồ chính xác và cập nhật
  - Dịch vụ địa lý đáng tin cậy
  - API mạnh mẽ với nhiều tính năng
  - SDKs cho nhiều nền tảng
- **Ứng dụng**:
  - Hiển thị vị trí bãi đỗ xe
  - Chỉ đường đến bãi đỗ
  - Tìm kiếm bãi đỗ gần nhất
  - Ước tính thời gian di chuyển

### 5.2. Payment Gateways

#### 5.2.1. Stripe / PayPal

- **APIs**: Stripe API / PayPal REST API
- **Lý do chọn**:
  - Xử lý thanh toán an toàn, đáng tin cậy
  - Hỗ trợ nhiều phương thức thanh toán
  - SDKs cho cả mobile và web
  - Tích hợp dễ dàng
- **Ứng dụng**:
  - Thanh toán trực tuyến cho dịch vụ đỗ xe
  - Subscription cho chủ bãi đỗ xe
  - Hoàn tiền và xử lý tranh chấp
  - Báo cáo tài chính

#### 5.2.2. Local Payment Solutions

- **Providers**: VNPay, Momo, ZaloPay (cho Việt Nam)
- **Lý do chọn**:
  - Phù hợp với thị trường địa phương
  - Thói quen người dùng địa phương
  - Phí giao dịch thấp hơn
  - Tích hợp với hệ thống ngân hàng địa phương
- **Ứng dụng**:
  - Thanh toán QR code tại bãi đỗ
  - Ví điện tử và top-up
  - Khuyến mãi và giảm giá địa phương

### 5.3. Firebase

- **Services**:
  - Firebase Authentication
  - Cloud Messaging (FCM)
  - Crashlytics
  - Analytics
  - Remote Config
- **Lý do chọn**:
  - Platform BaaS đáng tin cậy từ Google
  - Dễ dàng tích hợp với Flutter
  - Hỗ trợ nhiều tính năng quan trọng
  - Free tier hào phóng
- **Ứng dụng**:
  - Push notifications cho trạng thái đỗ xe
  - Analytics và user engagement
  - Crash reporting
  - A/B testing

## 6. Testing

### 6.1. Unit Testing

- **Frameworks**:
  - Flutter Test
  - pytest
- **Lý do chọn**:
  - Đảm bảo chất lượng code
  - Phát hiện lỗi sớm
  - Hỗ trợ refactoring an toàn
  - Tài liệu sống cho chức năng code

### 6.2. Integration Testing

- **Frameworks**:
  - Flutter Integration Test
  - pytest với TestClient của FastAPI
- **Lý do chọn**:
  - Kiểm tra tương tác giữa các thành phần
  - Phát hiện lỗi tích hợp
  - Đảm bảo luồng dữ liệu chính xác

### 6.3. E2E Testing

- **Frameworks**:
  - Appium
  - Playwright / Cypress
- **Lý do chọn**:
  - Kiểm tra toàn bộ hệ thống từ góc nhìn người dùng
  - Phát hiện lỗi trong môi trường thực tế
  - Đảm bảo trải nghiệm người dùng mượt mà

## 7. Mobile-Specific Technologies

### 7.1. Offline Sync

- **Thư viện**: Custom implementation với SQLite + RESTful API
- **Lý do chọn**:
  - Đảm bảo ứng dụng hoạt động khi không có kết nối mạng
  - Đồng bộ hóa tự động khi có kết nối
  - Xử lý xung đột dữ liệu
- **Ứng dụng**:
  - Ghi nhận xe vào/ra offline
  - Tính toán giá đỗ xe offline
  - Lưu trữ dữ liệu giao dịch cho đồng bộ sau

### 7.2. NFC Integration

- **Thư viện**: flutter_nfc_reader, nfc_manager
- **Lý do chọn**:
  - Tương tác không tiếp xúc, nhanh chóng
  - An toàn với mã hóa
  - Trải nghiệm người dùng mượt mà
- **Ứng dụng**:
  - Quét thẻ NFC xe vào/ra bãi đỗ
  - Xác thực thanh toán
  - Truy xuất thông tin xe nhanh chóng

### 7.3. Camera & Image Processing

- **Thư viện**: camera package, image, tflite_flutter
- **Lý do chọn**:
  - Truy cập camera thiết bị di động
  - Xử lý ảnh trong thời gian thực
  - Tích hợp mô hình AI
- **Ứng dụng**:
  - Nhận diện biển số xe
  - Scan QR code thanh toán
  - Chụp ảnh xe làm bằng chứng

## 8. Cập nhật công nghệ

Các công nghệ được liệt kê trong tài liệu này sẽ được đánh giá và cập nhật định kỳ 6 tháng/lần để đảm bảo dự án luôn sử dụng các công nghệ tốt nhất, an toàn nhất và hiệu quả nhất.

---

*Cập nhật ngày: 22/07/2025 - Đã bổ sung chi tiết về công nghệ AI Offline, NFC, đồng bộ hóa offline và quản lý license.*
