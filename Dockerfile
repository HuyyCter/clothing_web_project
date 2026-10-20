# ===== Bước 1: Build file WAR bằng Maven (JDK 21, khớp maven.compiler 21 trong pom.xml) =====
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app

# Copy pom.xml trước và tải dependency riêng -> được cache lại,
# lần build sau chỉ sửa code Java/JSP thì không phải tải lại thư viện.
COPY pom.xml .
RUN mvn -B dependency:go-offline

# Sau đó mới copy source và build WAR (target/ecommerce-web.war)
COPY src ./src
RUN mvn -B clean package -DskipTests

# ===== Bước 2: Chạy bằng Tomcat 10.1 (namespace jakarta.servlet) + JDK 21 =====
FROM tomcat:10.1-jdk21-temurin

# Xóa app mặc định của Tomcat, deploy WAR thành ROOT để truy cập ở "/"
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/target/ecommerce-web.war /usr/local/tomcat/webapps/ROOT.war

# Render cấp port qua biến PORT (mặc định 10000). Tomcat mặc định nghe 8080
# nên sed đổi sang $PORT lúc container khởi động.
ENV PORT=8080
# Giới hạn heap theo RAM của container (gói free Render chỉ 512MB), tránh bị OOM kill
ENV JAVA_OPTS="-XX:MaxRAMPercentage=70"
EXPOSE 8080
CMD ["sh", "-c", "sed -i \"s/8080/$PORT/g\" /usr/local/tomcat/conf/server.xml && catalina.sh run"]