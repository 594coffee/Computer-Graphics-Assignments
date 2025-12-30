public class Camera extends GameObject {
    Matrix4 projection = new Matrix4();
    Matrix4 worldView = new Matrix4();
    int wid;
    int hei;
    float near;
    float far;

    Camera() {
        wid = 256;
        hei = 256;
        worldView.makeIdentity();
        projection.makeIdentity();
        transform.position = new Vector3(0, 0, -50);
        name = "Camera";
    }

    Matrix4 inverseProjection() {
        Matrix4 invProjection = Matrix4.Zero();
        float a = projection.m[0];
        float b = projection.m[5];
        float c = projection.m[10];
        float d = projection.m[11];
        float e = projection.m[14];
        invProjection.m[0] = 1.0f / a;
        invProjection.m[5] = 1.0f / b;
        invProjection.m[11] = 1.0f / e;
        invProjection.m[14] = 1.0f / d;
        invProjection.m[15] = -c / (d * e);
        return invProjection;
    }

    Matrix4 Matrix() {
        return projection.mult(worldView);
    }

    void setSize(int w, int h, float n, float f) {
        wid = max(1, w);
        hei = max(1, h);
        near = max(0.1f, n); // 避免太小
        far = max(near + 10f, f); // far 必須大於 near
        // TODO HW3
        // This function takes four parameters, which are 
        // the width of the screen, the height of the screen
        // the near plane and the far plane of the camera.
        // Where GH_FOV has been declared as a global variable.
        // Finally, pass the result into projection matrix.
        
        float aspect = (float)wid / (float)hei;
        float fovRad = GH_FOV * (PI/180.0f);
    
        projection.makeIdentity();
        projection.m[0] = 1.0f / (tan(fovRad/2.0f) * aspect);
        projection.m[5] = 1.0f / tan(fovRad/2.0f);
        projection.m[10] = -(far+near)/(far-near);
        projection.m[11] = -1;
        projection.m[14] = -(2*far*near)/(far-near);
        projection.m[15] = 0;
    }

    void setPositionOrientation(Vector3 pos, float rotX, float rotY) {
        worldView = Matrix4.RotX(rotX).mult(Matrix4.RotY(rotY)).mult(Matrix4.Trans(pos.mult(-1)));
    }

    void setPositionOrientation() {
        worldView = Matrix4.RotX(transform.rotation.x).mult(Matrix4.RotY(transform.rotation.y))
                .mult(Matrix4.Trans(transform.position.mult(-1)));
    }

    void setPositionOrientation(Vector3 pos, Vector3 lookat) {
        // TODO HW3
        // This function takes two parameters, which are the position of the camera and
        // the point the camera is looking at.
        // We uses topVector = (0,1,0) to calculate the eye matrix.
        // Finally, pass the result into worldView matrix.

        Vector3 forward = lookat.sub(pos).unit_vector();
        Vector3 worldUp = new Vector3(0, 1, 0);
        Vector3 right = Vector3.cross(forward, worldUp).unit_vector();
        Vector3 up = Vector3.cross(right, forward).unit_vector();

    
        worldView.makeIdentity();
    
        // 右手坐標系，camera看向 -Z
        worldView.m[0] = right.x;
        worldView.m[1] = up.x;
        worldView.m[2] = -forward.x;
        worldView.m[3] = 0;
    
        worldView.m[4] = right.y;
        worldView.m[5] = up.y;
        worldView.m[6] = -forward.y;
        worldView.m[7] = 0;
    
        worldView.m[8] = right.z;
        worldView.m[9] = up.z;
        worldView.m[10] = -forward.z;
        worldView.m[11] = 0;
    
        worldView.m[12] = -Vector3.dot(right, pos);
        worldView.m[13] = -Vector3.dot(up, pos);
        worldView.m[14] = Vector3.dot(forward, pos);
        worldView.m[15] = 1;
    }
}
