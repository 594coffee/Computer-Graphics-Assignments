static final public class Vector {
    private float x;
    private float y;
    private float z;

    Vector() {
        x = 0;
        y = 0;
        z = 0;
    }

    Vector(float _a) {
        x = _a;
        y = _a;
        z = _a;
    }

    Vector(float _x, float _y, float _z) {
        x = _x;
        y = _y;
        z = _z;
    }

    float x() {
        return x;
    }

    float y() {
        return y;
    }

    float z() {
        return z;
    }

    float xyz(int i) {
        if (i == 0)
            return x;
        else if (i == 1)
            return y;
        else
            return z;
    }

    static Vector Zero() {
        return new Vector(0);
    }

    static Vector Ones() {
        return new Vector(1);
    }

    static Vector UnitX() {
        return new Vector(1, 0, 0);
    }

    static Vector UnitY() {
        return new Vector(0, 1, 0);
    }

    static Vector UnitZ() {
        return new Vector(0, 0, 1);
    }

    void set(float _x, float _y, float _z) {
        x = _x;
        y = _y;
        z = _z;
    }

    void setZero() {
        x = 0.0f;
        y = 0.0f;
        z = 0.0f;
    }

    void setOnes() {
        x = 1.0f;
        y = 1.0f;
        z = 1.0f;
    }

    void setUnitX() {
        x = 1.0f;
        y = 0.0f;
        z = 0.0f;
    }

    void setUnitY() {
        x = 0.0f;
        y = 1.0f;
        z = 0.0f;
    }

    void setUnitZ() {
        x = 0.0f;
        y = 0.0f;
        z = 1.0f;
    }

    public static Vector add(Vector a, Vector b) {
        Vector result = new Vector();
        result.x = a.x + b.x;
        result.y = a.y + b.y;
        result.z = a.z + b.z;
        return result;
    }

    public static Vector sub(Vector a, Vector b) {
        Vector result = new Vector();
        result.x = a.x - b.x;
        result.y = a.y - b.y;
        result.z = a.z - b.z;
        return result;
    }

    public static Vector mult(float n, Vector a) {
        Vector result = new Vector();
        result.x = n * a.x;
        result.y = n * a.y;
        result.z = n * a.z;
        return result;
    }

    public Vector mult(float n) {
        Vector result = new Vector();
        result.x = n * x;
        result.y = n * y;
        result.z = n * z;
        return result;
    }

    void product(float n) {

        x *= n;
        y *= n;
        z *= n;
    }

    public Vector dive(float n) {
        Vector result = new Vector();
        result.x = x / n;
        result.y = y / n;
        result.z = z / n;
        return result;
    }

    public float minComponent() {
        return min(x, min(y, z));
    }

    public float maxComponent() {
        return max(x, max(y, z));
    }

    public static Vector cross(Vector a, Vector b) {
        Vector result = new Vector();
        result.x = a.y * b.z - a.z * b.y;
        result.y = a.z * b.x - a.x * b.z;
        result.z = a.x * b.y - a.y * b.x;
        return result;
    }

    public static float dot(Vector a, Vector b) {
        return a.x * b.x + a.y * b.y + a.z * b.z;
    }

    public float norm() {
        return sqrt(x * x + y * y + z * z);
    }

    public void print() {
        println("x: " + x + " y: " + y + " z: " + z);
    }

    Vector unit_vector() {
        return Vector.mult(1 / this.norm(), this);
    }

    void normalize() {
        float a = 1 / this.norm();
        this.product(a);
    }

    public static Vector unit_vector(Vector v) {
        return Vector.mult(1 / v.norm(), v);
    }

    public Vector sub(Vector b) {
        Vector result = new Vector();
        result.x = x - b.x;
        result.y = y - b.y;
        result.z = z - b.z;
        return result;
    }

    public Vector add(Vector b) {
        Vector result = new Vector();
        result.x = x + b.x;
        result.y = y + b.y;
        result.z = z + b.z;
        return result;
    }

    public void minus(Vector b) {

        x -= b.x;
        y -= b.y;
        z -= b.z;
    }

    public void plus(Vector b) {

        x += b.x;
        y += b.y;
        z += b.z;
    }

    public float length_squared() {
        return x * x + y * y + z * z;
    }

    float length() {
        return sqrt(this.length_squared());
    }

    boolean near_zero() {
        float s = 1e-8;
        return (abs(x) < s) && abs(y) < s && abs(z) < s;
    }

    Vector product(Vector v) {
        Vector result = new Vector();
        result.x = x * v.x;
        result.y = y * v.y;
        result.z = z * v.z;
        return result;
    }

    Vector inv() {
        return new Vector(1 / x, 1 / y, 1 / z);
    }

    float magSq() {
        return x * x + y * y + z * z;
    }

    void clipMag(float m) {
        float r = magSq() / (m * m);
        if (r > 1) {
            float sr = sqrt(r);
            x /= sr;
            y /= sr;
            z /= sr;
        }
    }

    Vector copy() {
        return new Vector(x, y, z);
    }

    void copy(Vector b) {
        x = b.x;
        y = b.y;
        z = b.z;
    }

    @Override
    public String toString() {
        return "x : " + x + " y : " + y + " z : " + z;
    }
}
