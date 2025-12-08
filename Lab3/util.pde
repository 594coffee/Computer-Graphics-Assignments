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
    // TODO HW2
    // You need to find the bounding box of the vertexes v.
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

    /*Vector3 recordminV = new Vector3(0);
    Vector3 recordmaxV = new Vector3(999);
    Vector3[] result = { recordminV, recordmaxV };
    return result;*/
    
    /*Vector3 recordminV = new Vector3(1.0 / 0.0);
    Vector3 recordmaxV = new Vector3(-1.0 / 0.0);
    Vector3[] result = { recordminV, recordmaxV };
    return result;*/
    Vector3 recordminV = new Vector3(minX, minY, 0);
    Vector3 recordmaxV = new Vector3(maxX, maxY, 0);
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


/*public float getDepth(float x, float y, Vector3[] vertex) {
    // TODO HW3
    // You need to calculate the depth (z) in the triangle (vertex) based on the
    // positions x and y. and return the z value;

    Vector3 v0 = vertex[0];
    Vector3 v1 = vertex[1];
    Vector3 v2 = vertex[2];

    // 計算重心座標 (Barycentric coordinates)
    float denom = (v1.y - v2.y)*(v0.x - v2.x) + (v2.x - v1.x)*(v0.y - v2.y);
    if (denom == 0) return 1.0f; // 三角形退化，返回最遠

    float alpha = ((v1.y - v2.y)*(x - v2.x) + (v2.x - v1.x)*(y - v2.y)) / denom;
    float beta  = ((v2.y - v0.y)*(x - v2.x) + (v0.x - v2.x)*(y - v2.y)) / denom;
    float gamma = 1.0f - alpha - beta;

    // 1️⃣ 計算 camera space Z
    float z = alpha * v0.z + beta * v1.z + gamma * v2.z;

    //println("Z:", z);

    return z;

}*/
public float getDepth(float x, float y, Vector3[] vertex) {
    // vertex 是 triangle 三個頂點，已經是 camera space
    Vector3 v0 = vertex[0];
    Vector3 v1 = vertex[1];
    Vector3 v2 = vertex[2];

    // 計算重心座標
    float denom = (v1.y - v2.y)*(v0.x - v2.x) + (v2.x - v1.x)*(v0.y - v2.y);
    if (denom == 0) return 1.0f; // 三角形退化

    float alpha = ((v1.y - v2.y)*(x - v2.x) + (v2.x - v1.x)*(y - v2.y)) / denom;
    float beta  = ((v2.y - v0.y)*(x - v2.x) + (v0.x - v2.x)*(y - v2.y)) / denom;
    float gamma = 1.0f - alpha - beta;

    // 1️計算 camera space Z
    float z_cam = alpha * v0.z + beta * v1.z + gamma * v2.z;

    // 2️將 camera space Z 轉到 clip space Z，再除以 w 得到 NDC z
    // projection matrix 元素
    float near = main_camera.near;
    float far = main_camera.far;

    // 透視投影公式 (OpenGL style)
    float z_ndc = (-(far + near) / (far - near) * z_cam - 2 * far * near / (far - near)) / (-z_cam);

    // z_ndc 範圍 -1 ~ 1
    //println("Z:", z_ndc);
    //在沒有camera時正常
    //return z_ndc;
    return 0;
}

float[] barycentric(Vector3 P, Vector4[] verts) {

    Vector3 A = verts[0].homogenized();
    Vector3 B = verts[1].homogenized();
    Vector3 C = verts[2].homogenized();

    // TODO HW4
    // Calculate the barycentric coordinates of point P in the triangle verts using
    // the barycentric coordinate system.

    float[] result = { 0.0, 0.0, 0.0 };

    return result;
}
