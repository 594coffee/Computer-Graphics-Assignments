- [x] (25%) Correctly implement the barycentric.
- 計算一個點在三角形內的位置比例，用於內插頂點屬性（如顏色、UV、法線、深度）。
- 給定三角形頂點 A,B,C 與點 P，計算係數 α,β,γ 使得：P=αA+βB+γC,α+β+γ=1
- 光柵化時用來內插顏色、UV 或法線。
- 判斷點是否在三角形內（如果任一 barycentric 值 < 0，點在外面）。
- [x] (25%) Correctly implement Phong Shading.
- 逐像素光照計算，每個像素都使用法線計算光照。
- 包含 Ambient + Diffuse + Specular 光照模型：
  - Ambient：環境光，常數照亮。
  - Diffuse：漫反射，依法線與光線角度計算。
  - Specular：鏡面反射，依視角與光線計算高光。
- 法線內插到每個像素，再計算光照 → 光滑高光。
- [x] (25%) Correctly implement Flat Shading.
- 逐面光照計算，整個三角形使用相同的光照顏色。
- 通常取三角形 一個頂點或三角形法線 計算光照。
- 產生「平面化」效果，每個面顏色一致。
- 運算簡單，效能高。
- [x] (25%) Correctly implement Gouraud Shading.
- 逐頂點光照計算，在頂點處計算光照顏色，再對三角形內部進行 顏色內插。
- 漫反射和鏡面反射光照在頂點計算 → 再使用 barycentric 內插到像素。
- 光滑效果比 Flat Shading 好，但高光可能在三角形內部消失（因為是頂點內插）。
- 運算比 Phong 快，但比 Flat 精細。
- [ ] [+1.5 Semester Score] Successfully implement Texture Shading OR Done something COOL AND GOOD.
- 有運用ChatGPT輔助
  - 用於debug居多
  - 再來一一實現功能
<img width="1002" height="632" alt="image" src="https://github.com/user-attachments/assets/288afb12-a5c1-45f8-b9cd-45b2f25255a4" />
<img width="1002" height="632" alt="image" src="https://github.com/user-attachments/assets/6b61f880-27ae-4370-833b-c54cb8814103" />
<img width="1002" height="632" alt="image" src="https://github.com/user-attachments/assets/408b5da3-c726-476b-9db4-434579988c35" />
