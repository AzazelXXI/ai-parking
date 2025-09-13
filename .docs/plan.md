# Đề án: Ứng dụng quản lý bãi giữ xe tự động bằng AI
Mục tiêu: Xây dựng hệ thống quản lý bãi xe tự động sử dụng AI để phát hiện biển số và nhận diện khuôn mặt, từ đó tự động ghi nhận vào/ra, tính phí, quản trị khách hàng và bảo mật.

## 1. Chức năng chính (features)
- Quét và nhận diện biển số (ANPR) khi xe vào/ra.
- Nhận diện khuôn mặt (tùy chọn — đăng ký người dùng/khách hàng) để xác thực chủ xe.
- Ghi nhận thời gian vào/ra, tính phí tự động theo biểu phí.
- Quản trị bãi (danh sách xe, lịch sử vào/ra, doanh thu, xuất báo cáo).
- Cảnh báo bất thường (xe nghi ngờ, biển số blacklist).
- Giao diện admin (web) + màn hình hiển thị cho bảo vệ.
- Tích hợp điều khiển barrier/chuông (via relay, PLC hoặc API).
- Lưu trữ ảnh kèm thời điểm (log) cho việc tra cứu và bằng chứng.

## 2. Kiến trúc tổng quan
- Camera -> Edge device (RPI / Jetson / PC) chạy inference YOLOv8 (plate detection) + face detection -> OCR + face recognition -> gửi sự kiện (entry/exit) lên Backend.
- Backend (REST/GraphQL API): nhận event, xử lý business logic, database, tính phí, authentication, dashboard.
- Frontend: Web admin (React/Vue) để quản trị, tra cứu, báo cáo.
- Storage: Database (Postgres/MySQL) + file storage cho ảnh (S3 hoặc local).
- Optional: Message queue (RabbitMQ / Redis Streams / Kafka) nếu cần scale.
- Deployment: Edge processing (low latency) + Backend trên cloud / server school.

Luồng dữ liệu:
1. Camera chụp frame → Edge inference (YOLOv8) phát hiện plate, crop plate image.
2. OCR plate image → trả về chuỗi biển số.
3. Face detection + embedding → so khớp với DB người dùng nếu cần.
4. Edge gửi POST /api/events {plate, plate_image_url, face_id?, face_image_url?, timestamp, cam_id, confidence}.
5. Backend logic: xác định entry hay exit (dựa vào DB trạng thái), tính phí, tạo record, kích hoạt barrier nếu OK.
6. Frontend hiển thị real-time.

## 3. Công nghệ & thư viện gợi ý
- Model detection: YOLOv8 (Ultralytics) cho detect biển số và có thể cho detect toàn xe/face box.
- OCR: Tesseract (cấu hình tốt + tiền xử lý), hoặc PaddleOCR, EasyOCR; với biển số nên train/finetune OCR hoặc dùng CRNN/LPRNet cho tiếng/format địa phương.
- Face: MTCNN / RetinaFace (detection), ArcFace / FaceNet / InsightFace (embedding), Faiss cho tìm kiếm embedding.
- Backend: Python (FastAPI/Flask/Django) hoặc Node.js (Express/Nest).
- Database: PostgreSQL.
- Storage: MinIO (S3 compatible) hoặc AWS S3 (nếu có).
- Frontend: React + Tailwind/Antd.
- Edge device: NVIDIA Jetson Nano/Xavier hoặc Raspberry Pi 4 (nếu xử lý nhẹ) + camera RTSP/USB.
- Containerization: Docker, docker-compose; Kubernetes nếu cần scale.
- Annotation & train: LabelImg, Roboflow, Ultralytics train.

## 4. Thiết kế DB (gợi ý bảng chính)
- users (id, name, phone, email, role, face_embedding, created_at)
- vehicles (id, owner_user_id, plate_normalized, vehicle_type, notes)
- events (id, vehicle_id?, plate_text, plate_confidence, face_user_id?, face_confidence, cam_id, event_type [entry|exit|unknown], timestamp, image_url, processed_by)
- sessions (id, event_in_id, event_out_id, duration, fee, paid_flag, created_at)
- cams (id, name, location, rtsp_url)
- blacklists (id, plate_text, reason, created_at)
- payments (id, session_id, amount, method, timestamp)
- logs (id, level, message, meta, timestamp)

## 5. Xử lý ANPR & Face recognition (chi tiết)
- Plate detection (YOLOv8) → crop → pre-process (binarize, deskew, resize) → OCR model.
- Nếu OCR trả về chuỗi không chuẩn → apply regex normalizing (ví dụ Việt Nam: 2-4 ký tự số + chữ).
- Face pipeline: detect face → align → embedding → so sánh cosine distance với DB embeddings. Chọn threshold (ví dụ 0.35~0.45 tuỳ model).
- Khi nhận diện plate + face cùng lúc: ưu tiên xác thực bằng face nếu tồn tại (độ an toàn cao hơn).

## 6. Tính toán entry/exit
Chiến lược phát hiện entry vs exit:
- Đơn giản: camera ở cổng vào riêng / cổng ra riêng (cam_id cho biết).
- Nếu chỉ 1 camera: xác định hướng di chuyển (optical flow / tracking) hoặc dựa vào trạng thái cuối cùng trong DB (nếu plate đã in parking -> hiện là exit).
- Cẩn thận xử lý trường hợp same plate nhiều lần (biến rời/đến, lock thời gian ngắn) — cần debounce/time window (ví dụ 30s).

## 7. Bảo mật & Quyền riêng tư
- Lưu trữ ảnh / face embeddings: mã hóa khi lưu, hạn chế quyền truy cập.
- Xoá dữ liệu theo chính sách (ví dụ giữ tối đa X ngày).
- Thông báo và xin phép người dùng khi dùng face recognition (pháp lý phụ thuộc quốc gia).
- Audit log: ai xem ảnh, ai chỉnh sửa thông tin.

## 8. Hiệu năng & scale
- Edge inference: giảm latency, chỉ gửi metadata + thumbnail lên server.
- Batch uploads cho logs/ảnh lớn.
- Dùng Faiss / Annoy cho tìm kiếm embedding nếu DB lớn.
- Kiểm thử tải (concurrent events) để dimension backend.

## 9. Đánh giá model & metrics
- Detection: mAP@0.5 cho YOLOv8 trên tập test.
- OCR: character accuracy, plate-level accuracy.
- Face: FAR/FRR, ROC, threshold calibration trên tập validation.
- Latency: đo thời gian từ frame đến event (ms).

## 10. Dataset & annotation tips
- Thu thập ảnh biển số với angle/lighting khác nhau, blur, occlusion.
- Augmentation: brightness, blur, noise, rotation.
- Ghi đúng bounding box cho plate, face.
- Nếu ít dữ liệu: dùng transfer learning, synthetic data (Roboflow tạo biến thể).

## 11. Kiểm thử & demo cho đồ án
- Chuẩn bị 1 kịch bản demo: xe vào, hệ thống đọc plate, mở barrier, hiển thị thông tin, sau 10 phút xe ra, hệ thống tính phí và in hóa đơn.
- Ghi video demo + live demo: show logs, DB entry và ảnh kèm timestamp.
- Test edge cases: plate sai OCR, face mismatch, blacklist.

## 12. Vấn đề pháp lý / đạo đức
- Xin phép quay/ghi nhận khuôn mặt nếu yêu cầu.
- Chỉ lưu giữ dữ liệu cần thiết, cho phép xóa khi người dùng yêu cầu.
- Thông báo minh bạch về cách dùng dữ liệu.

## 13. Roadmap đề xuất cho học kỳ (~12 tuần)
Week 1: Phân tích yêu cầu, chọn công nghệ, thiết kế ER, chuẩn bị dataset.
Week 2-3: Triển khai pipeline YOLOv8 detect trên edge, crop plate.
Week 4: Tích hợp OCR + test accuracy; tune preprocessing.
Week 5: Triển khai face detection & embeddings; đăng ký user flow.
Week 6: Backend cơ bản (FastAPI) + DB; API event ingestion.
Week 7: Logic entry/exit + fee calculation; tạo sessions.
Week 8: Frontend admin cơ bản (thống kê, lịch sử).
Week 9: Tích hợp barrier control (simulated / relay).
Week 10: Logging, error handling, security + encrypt storage.
Week 11: Testing, calibration thresholds, performance tuning.
Week 12: Chuẩn bị báo cáo, slide, demo video & live demo.

## 14. Gợi ý các endpoint API (FastAPI style)
- POST /api/events — nhận event từ edge {plate, plate_conf, cam_id, image_url, timestamp, face_id?, face_conf?}
- GET /api/vehicles/{plate}
- POST /api/vehicles — đăng ký chủ xe
- GET /api/events?from=&to=&plate=
- POST /api/sessions/{id}/pay

## 15. Những lỗi thường gặp & cách khắc phục
- OCR sai do ảnh mờ → tăng shutter, crop chặt, denoise, tăng contrast.
- False positive face match → giảm độ nhạy, chuyển sang human-in-loop (bảo vệ confirm).
- Nhiều false plate reads → thêm whitelist/blacklist & heuristics.

## 16. Demo checklist (trước buổi bảo vệ)
- Có 3-5 video clip chứng minh pipeline chạy end-to-end.
- DB có logs, sessions, payment record.
- Frontend hiển thị danh sách real-time.
- Nêu rõ metrics của model (mAP, OCR accuracy, face ROC).
- Nêu rõ rủi ro & biện pháp pháp lý.

## 17. Tài nguyên & tham khảo
- Ultralytics YOLOv8 documentation
- PaddleOCR / EasyOCR docs
- InsightFace / ArcFace implementations
- Roboflow, LabelImg

---

Nếu bạn muốn, mình có thể:
- Viết API skeleton (FastAPI) cho backend.
- Viết mẫu pipeline inference (script edge) tích hợp YOLOv8 -> OCR -> gửi event.
- Viết schema DB SQL.
- Viết README + slides demo mẫu.

Cho mình biết bạn muốn bắt đầu ở phần nào (ví dụ: "viết backend skeleton" hoặc "viết script inference edge cho YOLOv8 -> OCR"), mình sẽ tạo file mẫu và code cụ thể.