  import javax.swing.JFileChooser;
  import javax.swing.filechooser.FileNameExtensionFilter;
  
  public Vector4 renderer_size;
  static public float GH_FOV = 45.0f;
  static public float GH_NEAR_MIN = 1e-3f;
  static public float GH_NEAR_MAX = 1e-1f;
  static public float GH_FAR = 1000.0f;
  
  public boolean debug = true;
  
  public float[] GH_DEPTH;
  public PImage renderBuffer;
  
  Engine engine;
  Camera main_camera;
  Vector3 cam_position;
  Vector3 lookat;
  
  void setup() {
      size(1000, 600);
      renderer_size = new Vector4(20, 50, 520, 550);
      cam_position = new Vector3(0, 0, -10);
      lookat = new Vector3(0, 0, 0);
      setDepthBuffer();
      main_camera = new Camera();
      engine = new Engine();
      
  }
  
  void setDepthBuffer(){
      renderBuffer = new PImage(int(renderer_size.z - renderer_size.x) , int(renderer_size.w - renderer_size.y));
      GH_DEPTH = new float[int(renderer_size.z - renderer_size.x) * int(renderer_size.w - renderer_size.y)];
      for(int i = 0 ; i < GH_DEPTH.length;i++){
          GH_DEPTH[i] = 1.0;
          renderBuffer.pixels[i] = color(1.0*250);
      }
  }

  void draw() {
      background(255);
      cameraControl();
      engine.run();
  }
  
  String selectFile() {
      JFileChooser fileChooser = new JFileChooser();
      fileChooser.setCurrentDirectory(new File("."));
      fileChooser.setFileSelectionMode(JFileChooser.FILES_ONLY);
      FileNameExtensionFilter filter = new FileNameExtensionFilter("Obj Files", "obj");
      fileChooser.setFileFilter(filter);
  
      int result = fileChooser.showOpenDialog(null);
      if (result == JFileChooser.APPROVE_OPTION) {
          String filePath = fileChooser.getSelectedFile().getAbsolutePath();
          return filePath;
      }
      return "";
  }
  
  // 視角兩個角度
  float yaw = 0;
  float pitch = 0;
  
  // 滑鼠旋轉
  boolean rotating = false;
  
  
  // =======================
  // 滑鼠（右鍵）拖曳旋轉
  // =======================
  
  void mousePressed() {
      if (mouseButton == RIGHT) {
          rotating = true;
      }
  }
  
  void mouseReleased() {
      if (mouseButton == RIGHT) {
          rotating = false;
      }
  }
  
  void mouseDragged() {
      if (rotating) {
          float sensitivity = 0.01;
  
          yaw   += (mouseX - pmouseX) * sensitivity;
          pitch += (mouseY - pmouseY) * sensitivity;
  
          // 限制 pitch，避免翻轉
          pitch = constrain(pitch, -1.5, 1.5);
      }
  }
 
  void cameraControl(){
      // You can write your own camera control function here.
      // Use setPositionOrientation(Vector3 position,Vector3 lookat) to modify the ViewMatrix.
      // Hint : Use keyboard event and mouse click event to change the position of the camera.       
      // 依 yaw/pitch 計算 forward
      Vector3 forward = new Vector3(
          cos(pitch) * sin(yaw),
          sin(pitch),
          cos(pitch) * cos(yaw)
      ).unit_vector();
  
      // lookat = cam_position + forward
      lookat = cam_position.add(forward);
  
      // 更新相機
      main_camera.setPositionOrientation(cam_position, lookat);
  }
