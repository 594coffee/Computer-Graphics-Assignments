public void CGLine(float x1, float y1, float x2, float y2) {
    stroke(0);
    line(x1, y1, x2, y2);
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
    // You need to check the coordinate p(x,v) if inside the vertexes. 
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
    float minX = Float.POSITIVE_INFINITY;
    float minY = Float.POSITIVE_INFINITY;
    float maxX = Float.NEGATIVE_INFINITY;
    float maxY = Float.NEGATIVE_INFINITY;

    for (Vector3 p : v) {
        if (p.x < minX) minX = p.x;
        if (p.y < minY) minY = p.y;
        if (p.x > maxX) maxX = p.x;
        if (p.y > maxY) maxY = p.y;
    }

    Vector3 recordminV = new Vector3(minX, minY, 0);
    Vector3 recordmaxV = new Vector3(maxX, maxY, 0);
    Vector3[] result = { recordminV, recordmaxV };
    return result;
}


public Vector3[] Sutherland_Hodgman_algorithm(Vector3[] points, Vector3[] boundary) {
    /*ArrayList<Vector3> input = new ArrayList<Vector3>();
    ArrayList<Vector3> output = new ArrayList<Vector3>();
    for (int i = 0; i < points.length; i += 1) {
        input.add(points[i]);
    }

    // TODO HW2
    // You need to implement the Sutherland Hodgman Algorithm in this section.
    // The function you pass 2 parameter. One is the vertexes of the shape "points".
    // And the other is the vertexes of the "boundary".
    // The output is the vertexes of the polygon.

    output = input;

    Vector3[] result = new Vector3[output.size()];
    for (int i = 0; i < result.length; i += 1) {
        result[i] = output.get(i);
    }
    return result;*/
    return points;
}

public float getDepth(float x, float y, Vector3[] vertex) {
    // TODO HW3
    // You need to calculate the depth (z) in the triangle (vertex) based on the
    // positions x and y. and return the z value;

    Vector3 v0 = vertex[0];
    Vector3 v1 = vertex[1];
    Vector3 v2 = vertex[2];

    float denom =
        (v1.y - v2.y)*(v0.x - v2.x) +
        (v2.x - v1.x)*(v0.y - v2.y);

    if (abs(denom) < 1e-6) return 1.0f;

    float alpha =
        ((v1.y - v2.y)*(x - v2.x) +
         (v2.x - v1.x)*(y - v2.y)) / denom;

    float beta =
        ((v2.y - v0.y)*(x - v2.x) +
         (v0.x - v2.x)*(y - v2.y)) / denom;

    float gamma = 1.0f - alpha - beta;

    // s_Position 已經是 homogenized (NDC)
    float z = alpha*v0.z + beta*v1.z + gamma*v2.z;

    return z;
}

float[] barycentric(Vector3 P, Vector4[] verts) {

    // 1. Clip → NDC
    Vector3 A = verts[0].homogenized();
    Vector3 B = verts[1].homogenized();
    Vector3 C = verts[2].homogenized();

    // 2. Triangle area (signed)
    float areaABC = (B.x - A.x)*(C.y - A.y)
                  - (B.y - A.y)*(C.x - A.x);

    if (Math.abs(areaABC) < 1e-6)
        return new float[]{ -1f, -1f, -1f };

    // ⭐ 關鍵：記住方向
    float invArea = 1.0f / areaABC;

    // 3. Raw barycentric (same orientation)
    float alpha = ((B.x - P.x)*(C.y - P.y)
                 - (B.y - P.y)*(C.x - P.x)) * invArea;

    float beta  = ((C.x - P.x)*(A.y - P.y)
                 - (C.y - P.y)*(A.x - P.x)) * invArea;

    float gamma = 1.0f - alpha - beta;

    // 4. Inside test（容忍浮點誤差）
    if (alpha < -1e-5 || beta < -1e-5 || gamma < -1e-5)
        return new float[]{ -1f, -1f, -1f };

    // 5. Perspective-correct interpolation
    float w0 = 1.0f / verts[0].w;
    float w1 = 1.0f / verts[1].w;
    float w2 = 1.0f / verts[2].w;

    float sum = alpha*w0 + beta*w1 + gamma*w2;
    alpha = alpha*w0 / sum;
    beta  = beta*w1 / sum;
    gamma = gamma*w2 / sum;

    return new float[]{ alpha, beta, gamma };
}


Vector3 interpolation(float[] abg, Vector3[] v) {
    return v[0].mult(abg[0]).add(v[1].mult(abg[1])).add(v[2].mult(abg[2]));
}

Vector4 interpolation(float[] abg, Vector4[] v) {
    return v[0].mult(abg[0]).add(v[1].mult(abg[1])).add(v[2].mult(abg[2]));
}

float interpolation(float[] abg, float[] v) {
    return v[0] * abg[0] + v[1] * abg[1] + v[2] * abg[2];
}
