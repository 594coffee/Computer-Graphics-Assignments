public abstract class Material {
    Vector3 albedo = new Vector3(0.9, 0.9, 0.9);
    Shader shader;

    Material() {
        // TODO HW4
        // In the Material, pass the relevant attribute variables and uniform variables
        // you need.
        // In the attribute variables, include relevant variables about vertices,
        // and in the uniform, pass other necessary variables.
        // Please note that a Material will be bound to the corresponding Shader.
    }

    abstract Vector4[][] vertexShader(Triangle triangle, Matrix4 M);

    abstract Vector4 fragmentShader(Vector3 position, Vector4[] varing);

    void attachShader(Shader s) {
        shader = s;
    }
}

public class DepthMaterial extends Material {
    DepthMaterial() {
        shader = new Shader(new DepthVertexShader(), new DepthFragmentShader());
    }

    Vector4[][] vertexShader(Triangle triangle, Matrix4 M) {
        Matrix4 MVP = main_camera.Matrix().mult(M);
        Vector3[] position = triangle.verts;
        Vector4[][] r = shader.vertex.main(new Object[] { position }, new Object[] { MVP });
        return r;
    }

    Vector4 fragmentShader(Vector3 position, Vector4[] varing) {
        return shader.fragment.main(new Object[] { position });
    }
}

public class PhongMaterial extends Material {
    Vector3 Ka = new Vector3(0.2, 0.2, 0.2);
    float Kd = 0.6;
    float Ks = 0.9;
    float m = 50;

    PhongMaterial() {
        shader = new Shader(new PhongVertexShader(), new PhongFragmentShader());
    }

    Vector4[][] vertexShader(Triangle triangle, Matrix4 M) {
        Matrix4 MVP = main_camera.Matrix().mult(M);
        Vector3[] position = triangle.verts;
        Vector3[] normal = triangle.normal;
        Vector4[][] r = shader.vertex.main(new Object[] { position, normal }, new Object[] { MVP, M });
        return r;
    }

    Vector4 fragmentShader(Vector3 position, Vector4[] varing) {

        return shader.fragment
                .main(new Object[] { position, varing[0].xyz(), varing[1].xyz(), albedo, new Vector3(Kd, Ks, m) });
    }

}

public class FlatMaterial extends Material {
    Vector3 Kd = new Vector3(0.5f, 0.5f, 0.5f);
    Vector3 Ks = new Vector3(0.5f, 0.5f, 0.5f);
    float shininess = 20f;
    Vector3 faceNormal; // 面法向量

    FlatMaterial() {
        shader = new Shader(new FlatVertexShader(), new FlatFragmentShader());
    }

    Vector4[][] vertexShader(Triangle triangle, Matrix4 M) {
        Matrix4 MVP = main_camera.Matrix().mult(M);
        Vector3[] position = triangle.verts;

        // 計算面法向量
        Vector3 edge1 = Vector3.sub(position[1], position[0]);
        Vector3 edge2 = Vector3.sub(position[2], position[0]);
        faceNormal = Vector3.cross(edge1, edge2).unit_vector();

        // 返回 gl_Position 供 rasterization
        Vector4[] gl_Position = new Vector4[3];
        for (int i = 0; i < 3; i++) {
            gl_Position[i] = MVP.mult(position[i].getVector4(1.0f));
        }

        return new Vector4[][] { gl_Position }; // 只返回 gl_Position
    }

    Vector4 fragmentShader(Vector3 position, Vector4[] varing) {
        // 不需要從 varying 拿任何材質
        return shader.fragment.main(new Object[]{position, this});
    }
}



public class GouraudMaterial extends Material {
    Vector3 Ka = new Vector3(0.3f, 0.3f, 0.3f); // ambient
    float Kd = 0.5f;
    float Ks = 0.5f;
    float m = 20f; // shininess

    GouraudMaterial() {
        shader = new Shader(new GouraudVertexShader(), new GouraudFragmentShader());
    }

    Vector4[][] vertexShader(Triangle triangle, Matrix4 M) {
        Matrix4 MVP = main_camera.Matrix().mult(M);
        Vector3[] position = triangle.verts;
        Vector3[] normal = triangle.normal;

        // 傳給 vertex shader：頂點位置與法向量
        Vector4[][] result = shader.vertex.main(
            new Object[]{position, normal},
            new Object[]{MVP, M, this} // 傳 Material 給 vertex shader 使用
        );
        return result;
    }

    Vector4 fragmentShader(Vector3 position, Vector4[] varing) {
        // varing[0..2] 已經是 vertex shader 計算好的顏色
        // Gouraud Fragment Shader 只做插值
        return shader.fragment.main(new Object[]{varing});
    }
}

public enum MaterialEnum {
    DM, FM, GM, PM;
}

public class TextureMaterial extends Material {
    Texture texture;
    TextureVertexShader tvShader;
    TextureFragmentShader tfShader;

    public TextureMaterial(String path) {
        super();
        texture = new Texture(path); // <-- 使用上面改好的建構子
        tvShader = new TextureVertexShader();
        tfShader = new TextureFragmentShader(texture);
    }

    @Override
    public Vector4[][] vertexShader(Triangle triangle, Matrix4 MVP) {
        Object[] attribute = { triangle.verts, triangle.uvs };
        Object[] uniform = { MVP };
        return tvShader.main(attribute, uniform);
    }

    @Override
    public Vector4 fragmentShader(Vector3 pixelPos, Vector4[] varying) {
        return tfShader.main(new Object[]{ varying[0] });
    }
}
