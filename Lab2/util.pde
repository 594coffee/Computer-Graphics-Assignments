public void CGLine(float x1, float y1, float x2, float y2) {
    // TODO HW1
    // Please paste your code from HW1 CGLine.
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

public boolean outOfBoundary(float x, float y) {
    if (x < 0 || x >= width || y < 0 || y >= height)
        return true;
    return false;
}

public void drawPoint(float x, float y, color c) {
    int index = (int) y * width + (int) x;
    if (outOfBoundary(x, y))
        return;
    pixels[index] = c;
}

public float distance(Vector3 a, Vector3 b) {
    Vector3 c = a.sub(b);
    return sqrt(Vector3.dot(c, c));
}

boolean pnpoly(float x, float y, Vector3[] vertexes) {
    // TODO HW2 
    // You need to check the coordinate p(x,v) if inside the vertices. 
    // If yes return true, vice versa.
    boolean inside = false;
    int n = vertexes.length;

    for (int i = 0, j = n - 1; i < n; j = i++) {
        float xi = vertexes[i].x;
        float yi = vertexes[i].y;
        float xj = vertexes[j].x;
        float yj = vertexes[j].y;

        boolean intersect = ((yi > y) != (yj > y)) &&
                            (x < (xj - xi) * (y - yi) / (yj - yi + 0.00001) + xi);
        if (intersect)
            inside = !inside;
    }
    return inside;
}

public Vector3[] findBoundBox(Vector3[] v) {
    
    
    // TODO HW2 
    // You need to find the bounding box of the vertices v.
    // r1 -------
    //   |   /\  |
    //   |  /  \ |
    //   | /____\|
    //    ------- r2
    float minX = Float.POSITIVE_INFINITY;
    float minY = Float.POSITIVE_INFINITY;
    float maxX = Float.NEGATIVE_INFINITY;
    float maxY = Float.NEGATIVE_INFINITY;

    // Loop through all polygon vertices
    for (int i = 0; i < v.length; i++) {
        Vector3 p = v[i];
        if (p.x < minX) minX = p.x;
        if (p.y < minY) minY = p.y;
        if (p.x > maxX) maxX = p.x;
        if (p.y > maxY) maxY = p.y;
    }

    Vector3 recordminV = new Vector3(0);
    Vector3 recordmaxV = new Vector3(999);
    Vector3[] result = { recordminV, recordmaxV };
    return result;

}

public Vector3[] Sutherland_Hodgman_algorithm(Vector3[] points, Vector3[] boundary) {
    ArrayList<Vector3> input = new ArrayList<Vector3>();
    for (int i = 0; i < points.length; i += 1) {
        input.add(points[i]);
    }

    // TODO HW2
    // You need to implement the Sutherland Hodgman Algorithm in this section.
    // The function you pass 2 parameter. One is the vertexes of the shape "points".
    // And the other is the vertices of the "boundary".
    // The output is the vertices of the polygon.
    for (int j = 0; j < boundary.length; j++) {
        if (input.size() == 0) break;
        ArrayList<Vector3> output = new ArrayList<Vector3>();
        Vector3 A = boundary[j];
        Vector3 B = boundary[(j + 1) % boundary.length];
        Vector3 S = input.get(input.size() - 1);

        for (int i = 0; i < input.size(); i++) {
            Vector3 P = input.get(i);

            boolean P_inside = inside(P, A, B);
            boolean S_inside = inside(S, A, B);

            if (P_inside) {
                if (!S_inside) {
                    output.add(intersection(S, P, A, B)); // Entering
                }
                output.add(P); // Always add P if it's inside
            } else if (S_inside) {
                output.add(intersection(S, P, A, B)); // Exiting
            }

            S = P; // Move to next edge
        }
        input = output; // Update the polygon to clipped version
    }

    // Convert back to array
    Vector3[] result = new Vector3[input.size()];
    for (int i = 0; i < input.size(); i++)
        result[i] = input.get(i);
    return result;
}

// Check if point P is inside edge AB using cross product
boolean inside(Vector3 p, Vector3 a, Vector3 b) {
    return (b.x - a.x) * (p.y - a.y) - (b.y - a.y) * (p.x - a.x) <= 0;
}

// Find intersection of line segment SP with boundary AB
Vector3 intersection(Vector3 s, Vector3 p, Vector3 a, Vector3 b) {
    float A1 = p.y - s.y;
    float B1 = s.x - p.x;
    float C1 = A1 * s.x + B1 * s.y;

    float A2 = b.y - a.y;
    float B2 = a.x - b.x;
    float C2 = A2 * a.x + B2 * a.y;

    float det = A1 * B2 - A2 * B1;
    if (det == 0) {
        return s; // Lines are parallel, return start
    } else {
        float x = (B2 * C1 - B1 * C2) / det;
        float y = (A1 * C2 - A2 * C1) / det;
        return new Vector3(x, y, 0);
    }
}
