public class PhongVertexShader extends VertexShader {
    Vector4[][] main(Object[] attribute, Object[] uniform) {
        Vector3[] aVertexPosition = (Vector3[]) attribute[0];
        Vector3[] aVertexNormal = (Vector3[]) attribute[1];
        Matrix4 MVP = (Matrix4) uniform[0];
        Matrix4 M = (Matrix4) uniform[1];
        Vector4[] gl_Position = new Vector4[3];
        Vector4[] w_position = new Vector4[3];
        Vector4[] w_normal = new Vector4[3];

        for (int i = 0; i < gl_Position.length; i++) {
            gl_Position[i] = MVP.mult(aVertexPosition[i].getVector4(1.0));
            w_position[i] = M.mult(aVertexPosition[i].getVector4(1.0));
            w_normal[i] = M.mult(aVertexNormal[i].getVector4(0.0));
        }

        Vector4[][] result = { gl_Position, w_position, w_normal };

        return result;
    }
}

public class PhongFragmentShader extends FragmentShader {
    Vector4 main(Object[] varying) {
        Vector3 position = (Vector3) varying[0];
        Vector3 w_position = (Vector3) varying[1];
        Vector3 w_normal = (Vector3) varying[2];
        Vector3 albedo = (Vector3) varying[3];
        Vector3 kdksm = (Vector3) varying[4];
        Light light = basic_light;
        Camera cam = main_camera;

        // TODO HW4
        // In this section, we have passed in all the variables you need.
        // Please use these variables to calculate the result of Phong shading
        // for that point and return it to GameObject for rendering
        // Normalize the normal
        Vector3 N = w_normal.unit_vector();
        // Light direction
        Vector3 L = Vector3.sub(light.light_color, w_position).unit_vector();
        // View direction
        Vector3 V = Vector3.sub(cam.transform.position, w_position).unit_vector();
        // Reflection vector
        float NdotL = Math.max(0f, Vector3.dot(N, L));
        Vector3 R = Vector3.sub(Vector3.mult(2f * NdotL, N), L).unit_vector();
        // Phong coefficients
        float kd = kdksm.x();        // diffuse coefficient
        float ks = kdksm.y();        // specular coefficient
        float shininess = kdksm.z(); // shininess exponent
        // Ambient term (simple constant)
        Vector3 ambient = albedo.mult(0.1f);
        // Diffuse term
        Vector3 diffuse = albedo.mult(kd * NdotL);
        // Specular term (white highlight)
        float RdotV = Math.max(0f, Vector3.dot(R, V));
        Vector3 specular = Vector3.Ones().mult(ks * (float)Math.pow(RdotV, shininess));
        // Final color
        Vector3 colorV = Vector3.add(Vector3.add(ambient, diffuse), specular);
        return new Vector4(colorV, 1f);
    }
}

public class FlatVertexShader extends VertexShader {
    Vector4[][] main(Object[] attribute, Object[] uniform) {
        Vector3[] aVertexPosition = (Vector3[]) attribute[0];
        Matrix4 MVP = (Matrix4) uniform[0];

        Vector4[] gl_Position = new Vector4[3];
        for (int i = 0; i < 3; i++) {
            gl_Position[i] = MVP.mult(aVertexPosition[i].getVector4(1.0f));
        }

        return new Vector4[][] { gl_Position }; // 只回傳 gl_Position
    }
}

public class FlatFragmentShader extends FragmentShader {
    Vector4 main(Object[] args) {
        Vector3 fragPos = (Vector3) args[0];
        FlatMaterial material = (FlatMaterial) args[1]; // 直接拿 material

        Vector3 albedo = material.albedo;
        Vector3 N = material.faceNormal; // 面法向量

        Light light = basic_light;
        Camera cam = main_camera;

        // Flat shading 光照計算
        N = N.unit_vector();
        Vector3 L = Vector3.sub(light.light_color, fragPos).unit_vector();
        Vector3 V = Vector3.sub(cam.transform.position, fragPos).unit_vector();
        float NdotL = Math.max(0f, Vector3.dot(N, L));
        Vector3 R = Vector3.sub(Vector3.mult(2f * NdotL, N), L).unit_vector();

        float kd = 0.5f;
        float ks = 0.5f;
        float shininess = 20f;

        Vector3 ambient = albedo.mult(0.1f);
        Vector3 diffuse = albedo.mult(kd * NdotL);
        float RdotV = Math.max(0f, Vector3.dot(R, V));
        Vector3 specular = Vector3.Ones().mult(ks * (float)Math.pow(RdotV, shininess));

        Vector3 colorV = Vector3.add(Vector3.add(ambient, diffuse), specular);

        return new Vector4(colorV, 1f);
    }
}



public class GouraudVertexShader extends VertexShader {
    Vector4[][] main(Object[] attribute, Object[] uniform) {
        Vector3[] aVertexPosition = (Vector3[]) attribute[0];
        Vector3[] aVertexNormal = (Vector3[]) attribute[1];
        Matrix4 MVP = (Matrix4) uniform[0];
        Matrix4 M = (Matrix4) uniform[1];
        GouraudMaterial material = (GouraudMaterial) uniform[2];

        Vector4[] gl_Position = new Vector4[3];
        Vector4[] vertexColor = new Vector4[3]; // 每個頂點光照結果

        for (int i = 0; i < 3; i++) {
            Vector3 worldPos = M.mult(aVertexPosition[i].getVector4(1.0f)).xyz();
            Vector3 worldNormal = M.mult(aVertexNormal[i].getVector4(0.0f)).xyz().unit_vector();

            // 光照計算 (Phong 模型)
            Vector3 N = worldNormal;
            Vector3 L = Vector3.sub(basic_light.light_color, worldPos).unit_vector();
            Vector3 V = Vector3.sub(main_camera.transform.position, worldPos).unit_vector();
            float NdotL = Math.max(0f, Vector3.dot(N, L));
            Vector3 R = Vector3.sub(Vector3.mult(2f * NdotL, N), L).unit_vector();

            Vector3 ambient = material.albedo.mult(0.1f);
            Vector3 diffuse = material.albedo.mult(material.Kd * NdotL);
            float RdotV = Math.max(0f, Vector3.dot(R, V));
            Vector3 specular = Vector3.Ones().mult(material.Ks * (float)Math.pow(RdotV, material.m));

            Vector3 colorV = Vector3.add(Vector3.add(ambient, diffuse), specular);
            vertexColor[i] = new Vector4(colorV, 1f);

            // 頂點位置轉 clip space
            gl_Position[i] = MVP.mult(aVertexPosition[i].getVector4(1.0f));
        }

        return new Vector4[][] { gl_Position, vertexColor };
    }
}


public class GouraudFragmentShader extends FragmentShader {
    Vector4 main(Object[] varying) {
        // 接收 interpolation 後的顏色
        Vector4[] vertexColor = (Vector4[]) varying[0];
        // 插值後已經是單一顏色
        return vertexColor[0]; // barycentric 已經做了插值
    }
}

public class TextureVertexShader extends VertexShader {
    @Override
    Vector4[][] main(Object[] attribute, Object[] uniform) {
        Vector3[] verts = (Vector3[]) attribute[0];
        Vector3[] uvs = (Vector3[]) attribute[1];
        Matrix4 MVP = (Matrix4) uniform[0];

        Vector4[] gl_Position = new Vector4[3];
        Vector4[] vUV = new Vector4[3];

        for (int i = 0; i < 3; i++) {
            gl_Position[i] = MVP.mult(verts[i].getVector4(1.0));
            vUV[i] = new Vector4(uvs[i].x, uvs[i].y, 0, 0); // Vector3 → Vector4
        }

        return new Vector4[][] { gl_Position, vUV };
    }
}


public class TextureFragmentShader extends FragmentShader {
    Texture texture;

    public TextureFragmentShader(Texture tex) {
        texture = tex;
    }

    @Override
    Vector4 main(Object[] varying) {
        Vector4 uv = (Vector4) varying[0]; // 頂點著色器傳過來的 varying
        return texture.getColor(uv.x, uv.y);
    }
}


public class Texture {
    int width;
    int height;
    int[] pixels;

    // 建構子直接傳入路徑
    public Texture(String path) {
        // 這裡寫你讀檔到 pixels 的邏輯
        width = 128; // 範例
        height = 128;
        pixels = new int[width * height];
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                int r = (x * 255) / (width - 1);
                int g = (y * 255) / (height - 1);
                int b = 0;
                int a = 255;
                pixels[y * width + x] = (a << 24) | (r << 16) | (g << 8) | b;
            }
        }
    }

    public Vector4 getColor(float u, float v) {
        u = Math.max(0.0f, Math.min(1.0f, u));
        v = Math.max(0.0f, Math.min(1.0f, v));
        int x = (int)(u * (width - 1));
        int y = (int)((1.0f - v) * (height - 1));
        int colorV = pixels[y * width + x];
        float a = ((colorV >> 24) & 0xFF)/255.0f;
        float r = ((colorV >> 16) & 0xFF)/255.0f;
        float g = ((colorV >> 8) & 0xFF)/255.0f;
        float b = (colorV & 0xFF)/255.0f;
        return new Vector4(r, g, b, a);
    }
}
