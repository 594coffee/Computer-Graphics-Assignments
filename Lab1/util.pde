public void CGLine(float x1, float y1, float x2, float y2) {
    /*
     stroke(0);
     noFill();
     line(x1,y1,x2,y2);
    */
    int colorVal = color(0, 0, 0);
    int ix1 = Math.round(x1), iy1 = Math.round(y1), ix2 = Math.round(x2), iy2 = Math.round(y2);
    int dx = Math.abs(ix2 - ix1), dy = Math.abs(iy2 - iy1);
    int sx = (ix1 < ix2) ? 1 : -1, sy = (iy1 < iy2) ? 1 : -1;
    int err = dx - dy;
    while (true) {
        drawPoint(ix1, iy1, colorVal);
        if (ix1 == ix2 && iy1 == iy2) break;
        int e2 = 2 * err;
        if (e2 > -dy) {
            err -= dy;
            ix1 += sx;
        }
        if (e2 < dx) {
            err += dx;
            iy1 += sy;
        }
    }
}

public void CGCircle(float xc, float yc, float r) {
    /*
    stroke(0);
    noFill();
    circle(xc,yc,r*2);
    */
    int colorVal = color(0, 0, 0);
    int x = 0;
    int y = Math.round(r);
    int d = 1 - y;

    while (x <= y) {
        // 8-way symmetr2
        drawPoint(xc + x, yc + y, colorVal);
        drawPoint(xc - x, yc + y, colorVal);
        drawPoint(xc + x, yc - y, colorVal);
        drawPoint(xc - x, yc - y, colorVal);
        drawPoint(xc + y, yc + x, colorVal);
        drawPoint(xc - y, yc + x, colorVal);
        drawPoint(xc + y, yc - x, colorVal);
        drawPoint(xc - y, yc - x, colorVal);

        x++;
        if (d < 0) {
            d += 2 * x + 1;
        } else {
            y--;
            d += 2 * (x - y) + 1;
        }
    }
}

public void CGEllipse(float xc, float yc, float r1, float r2) {
    /*
    stroke(0);
    noFill();
    ellipse(x,y,r1*2,r2*2);
    */
    int colorVal = color(0, 0, 0);
    float x = 0;
    float y = r2;

    float r12 = r1 * r1;
    float r22 = r2 * r2;
    float twor12 = 2 * r12;
    float twor22 = 2 * r22;

    float px = 0;
    float py = twor12 * y;

    // 區域 1
    float p = Math.round(r22 - (r12 * r2) + (0.25f * r12));
    while (px < py) {
        // 4-way symmetr2
        drawPoint(xc + x, yc + y, colorVal);
        drawPoint(xc - x, yc + y, colorVal);
        drawPoint(xc + x, yc - y, colorVal);
        drawPoint(xc - x, yc - y, colorVal);

        x++;
        px += twor22;
        if (p < 0) {
            p += r22 + px;
        } else {
            y--;
            py -= twor12;
            p += r22 + px - py;
        }
    }

    // 區域 2
    p = Math.round(r22 * (x + 0.5f) * (x + 0.5f) + r12 * (y - 1) * (y - 1) - r12 * r22);
    while (y >= 0) {
        drawPoint(xc + x, yc + y, colorVal);
        drawPoint(xc - x, yc + y, colorVal);
        drawPoint(xc + x, yc - y, colorVal);
        drawPoint(xc - x, yc - y, colorVal);

        y--;
        py -= twor12;
        if (p > 0) {
            p += r12 - py;
        } else {
            x++;
            px += twor22;
            p += r12 - py + px;
        }
    }
}

public void CGCurve(Vector p1, Vector p2, Vector p3, Vector p4) {
    /*
    stroke(0);
    noFill();
    bezier(p1.x,p1.y,p2.x,p2.y,p3.x,p3.y,p4.x,p4.y);
    */
    int colorVal = color(0, 0, 0);
    float approxLength = dist(p1.x(), p1.y(), p4.x(), p4.y());
    int steps = (int)(approxLength * 2); // 每個像素取 2 個點
    steps = max(steps, 50); // 最少50步，避免太少
    for (int i = 0; i <= steps; i++) {
        float t = i / (float) steps;
        float x = (float)(Math.pow(1 - t, 3) * p1.x() +
                          3 * Math.pow(1 - t, 2) * t * p2.x() +
                          3 * (1 - t) * t * t * p3.x() +
                          t * t * t * p4.x());
        float y = (float)(Math.pow(1 - t, 3) * p1.y() +
                          3 * Math.pow(1 - t, 2) * t * p2.y() +
                          3 * (1 - t) * t * t * p3.y() +
                          t * t * t * p4.y());
        drawPoint(x, y, colorVal);
    }

}

public void CGEraser(Vector p1, Vector p2) {
    // The background color is color(250);
    // You can use the mouse wheel to change the eraser range.
    int x1 = (int)p1.x;
    int y1 = (int)p1.y;
    int x2 = (int)p2.x;
    int y2 = (int)p2.y;

    loadPixels();
    color bgColor = color(250);
    for (int y = y1; y < y2; y++) {
        for (int x = x1; x < x2; x++) {
            int index = x + y * width;
            if (index >= 0 && index < pixels.length) {
                if (pixels[index] != bgColor) {
                    pixels[index] = bgColor;
                }
            }
        }
    }
    updatePixels();
}

public void drawPoint(float x, float y, color c) {
    stroke(c);
    point(x, y);
}

public float distance(Vector a, Vector b) {
    Vector c = a.sub(b);
    return sqrt(Vector.dot(c, c));
}
