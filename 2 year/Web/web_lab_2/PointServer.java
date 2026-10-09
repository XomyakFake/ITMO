import com.fastcgi.FCGIInterface;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

public class PointServer {
    private static final int MAX_BODY_SIZE = 8192;
    private static final List<Point> HISTORY = new ArrayList<Point>();
    private static final double[] ALLOWED_R = {1, 1.5, 2, 2.5, 3};

    public static void main(String[] args) {
        FCGIInterface fcgi = new FCGIInterface();
        while (fcgi.FCGIaccept() >= 0) {
            long startedAt = System.nanoTime();
            String serverTime = Instant.now().toString();
            try {
                Properties request = System.getProperties();
                String method = request.getProperty("REQUEST_METHOD", "GET");
                String json = handleRequest(method, request, startedAt, serverTime);
                sendResponse(200, json);
            } catch (BadRequestException exception) {
                sendResponse(400, errorJson(exception.getMessage(), startedAt, serverTime));
            } catch (MethodNotAllowedException exception) {
                sendResponse(405, errorJson("Разрешены GET, POST и DELETE.", startedAt, serverTime));
            } catch (Exception exception) {
                exception.printStackTrace(System.err);
                sendResponse(500, errorJson("Внутренняя ошибка сервера.", startedAt, serverTime));
            }
        }
    }

    private static String handleRequest(String method, Properties request, long startedAt, String serverTime)
            throws IOException, BadRequestException, MethodNotAllowedException {
        if ("GET".equals(method)) {
            return historyJson(startedAt, serverTime, null);
        }
        if ("POST".equals(method)) {
            Point point = readPoint(request);
            synchronized (HISTORY) {
                HISTORY.add(0, point);
            }
            return historyJson(startedAt, serverTime, point);
        }
        if ("DELETE".equals(method)) {
            synchronized (HISTORY) {
                HISTORY.clear();
            }
            return historyJson(startedAt, serverTime, null);
        }
        throw new MethodNotAllowedException();
    }

    private static Point readPoint(Properties request) throws IOException, BadRequestException {
        String contentType = request.getProperty("CONTENT_TYPE", "");
        if (!contentType.toLowerCase().startsWith("application/x-www-form-urlencoded")) {
            throw new BadRequestException("Ожидались данные формы application/x-www-form-urlencoded.");
        }

        int contentLength;
        try {
            contentLength = Integer.parseInt(request.getProperty("CONTENT_LENGTH", "0"));
        } catch (NumberFormatException exception) {
            throw new BadRequestException("Некорректная длина запроса.");
        }
        if (contentLength <= 0 || contentLength > MAX_BODY_SIZE) {
            throw new BadRequestException("Пустой запрос или слишком большой размер данных.");
        }

        byte[] body = readBody(System.in, contentLength);
        Map<String, String> form = parseForm(new String(body, StandardCharsets.UTF_8));
        double x = parseNumber(form.get("x"), "X");
        double y = parseNumber(form.get("y"), "Y");
        double radius = parseNumber(form.get("r"), "R");

        if (x < -3 || x > 5) {
            throw new BadRequestException("X должен находиться в диапазоне от -3 до 5.");
        }
        if (y <= -3 || y >= 3) {
            throw new BadRequestException("Y должен находиться строго между -3 и 3.");
        }
        if (!isAllowedRadius(radius)) {
            throw new BadRequestException("R должен быть равен 1, 1.5, 2, 2.5 или 3.");
        }

        return new Point(x, y, radius, checkHit(x, y, radius), Instant.now().toString());
    }

    private static byte[] readBody(InputStream input, int length) throws IOException, BadRequestException {
        ByteArrayOutputStream body = new ByteArrayOutputStream(length);
        byte[] buffer = new byte[1024];
        int remaining = length;
        while (remaining > 0) {
            int read = input.read(buffer, 0, Math.min(buffer.length, remaining));
            if (read < 0) {
                throw new BadRequestException("Запрос оборвался до получения всех данных.");
            }
            body.write(buffer, 0, read);
            remaining -= read;
        }
        return body.toByteArray();
    }

    private static Map<String, String> parseForm(String body) throws BadRequestException {
        Map<String, String> values = new HashMap<String, String>();
        try {
            String[] pairs = body.split("&");
            for (String pair : pairs) {
                String[] parts = pair.split("=", 2);
                String key = URLDecoder.decode(parts[0], "UTF-8");
                String value = parts.length > 1 ? URLDecoder.decode(parts[1], "UTF-8") : "";
                values.put(key, value);
            }
        } catch (IllegalArgumentException exception) {
            throw new BadRequestException("Некорректное кодирование формы.");
        } catch (java.io.UnsupportedEncodingException exception) {
            throw new BadRequestException("Не удалось декодировать данные формы.");
        }
        return values;
    }

    private static double parseNumber(String value, String field) throws BadRequestException {
        if (value == null || value.trim().isEmpty()) {
            throw new BadRequestException("Поле " + field + " не заполнено.");
        }
        try {
            double number = Double.parseDouble(value.trim().replace(',', '.'));
            if (Double.isNaN(number) || Double.isInfinite(number)) {
                throw new NumberFormatException();
            }
            return number;
        } catch (NumberFormatException exception) {
            throw new BadRequestException("Поле " + field + " должно быть числом.");
        }
    }

    private static boolean isAllowedRadius(double radius) {
        for (double allowedRadius : ALLOWED_R) {
            if (radius == allowedRadius) {
                return true;
            }
        }
        return false;
    }

    private static boolean checkHit(double x, double y, double radius) {
        if (x <= 0 && y >= 0 && x >= -radius && y <= radius) {
            return true;
        }
        if (x <= 0 && y <= 0 && x >= -radius && y >= -x - radius) {
            return true;
        }
        return x >= 0 && y >= 0 && x * x + y * y <= (radius / 2) * (radius / 2);
    }

    private static String historyJson(long startedAt, String serverTime, Point addedPoint) {
        StringBuilder json = new StringBuilder();
        json.append("{\"ok\":true,\"added\":");
        if (addedPoint == null) {
            json.append("null");
        } else {
            appendPoint(json, addedPoint);
        }
        json.append(",\"history\":[");
        synchronized (HISTORY) {
            for (int index = 0; index < HISTORY.size(); index++) {
                if (index > 0) {
                    json.append(',');
                }
                appendPoint(json, HISTORY.get(index));
            }
        }
        json.append("],\"serverTime\":");
        appendString(json, serverTime);
        json.append(",\"processingTimeMs\":")
            .append((System.nanoTime() - startedAt) / 1_000_000.0)
                .append('}');
        return json.toString();
    }

    private static String errorJson(String message, long startedAt, String serverTime) {
        StringBuilder json = new StringBuilder("{\"ok\":false,\"error\":");
        appendString(json, message);
        json.append(",\"history\":");
        appendHistory(json);
        json.append(",\"serverTime\":");
        appendString(json, serverTime);
        json.append(",\"processingTimeMs\":")
            .append((System.nanoTime() - startedAt) / 1_000_000.0)
                .append('}');
        return json.toString();
    }

    private static void appendHistory(StringBuilder json) {
        json.append('[');
        synchronized (HISTORY) {
            for (int index = 0; index < HISTORY.size(); index++) {
                if (index > 0) {
                    json.append(',');
                }
                appendPoint(json, HISTORY.get(index));
            }
        }
        json.append(']');
    }

    private static void appendPoint(StringBuilder json, Point point) {
        json.append("{\"x\":").append(point.x)
                .append(",\"y\":").append(point.y)
                .append(",\"r\":").append(point.radius)
                .append(",\"hit\":").append(point.hit)
                .append(",\"time\":");
        appendString(json, point.time);
        json.append('}');
    }

    private static void appendString(StringBuilder json, String value) {
        json.append('"');
        for (int index = 0; index < value.length(); index++) {
            char character = value.charAt(index);
            if (character == '"' || character == '\\') {
                json.append('\\').append(character);
            } else if (character == '\n') {
                json.append("\\n");
            } else if (character == '\r') {
                json.append("\\r");
            } else if (character == '\t') {
                json.append("\\t");
            } else if (character < 0x20) {
                json.append(String.format("\\u%04x", (int) character));
            } else {
                json.append(character);
            }
        }
        json.append('"');
    }

    private static void sendResponse(int status, String json) {
        String statusText = status == 200 ? "200 OK" : status == 400 ? "400 Bad Request"
                : status == 405 ? "405 Method Not Allowed" : "500 Internal Server Error";
        System.out.print("Status: " + statusText + "\r\n");
        System.out.print("Content-Type: application/json; charset=utf-8\r\n");
        System.out.print("Cache-Control: no-store\r\n\r\n");
        try {
            System.out.write(json.getBytes(StandardCharsets.UTF_8));
        } catch (IOException exception) {
            exception.printStackTrace(System.err);
        }
        System.out.flush();
    }

    private static class Point {
        private final double x;
        private final double y;
        private final double radius;
        private final boolean hit;
        private final String time;

        private Point(double x, double y, double radius, boolean hit, String time) {
            this.x = x;
            this.y = y;
            this.radius = radius;
            this.hit = hit;
            this.time = time;
        }
    }

    private static class BadRequestException extends Exception {
        private BadRequestException(String message) {
            super(message);
        }
    }

    private static class MethodNotAllowedException extends Exception {
    }
}
