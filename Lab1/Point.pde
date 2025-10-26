
public interface Shape {
    public void drawShape();
}

  public class Point implements Shape {
      ArrayList<Vector> points = new ArrayList<Vector>();
      float shapeStrokeWeight;
      public Point(ArrayList<Vector> p, float sw) {
          points = p;
          shapeStrokeWeight = sw;
      }
  
      @Override
      public void drawShape() {
          if (points.size() <= 1)
              return;
          strokeWeight(shapeStrokeWeight);
          for (int i = 0; i < points.size() - 1; i++) {
              Vector p1 = points.get(i);
              Vector p2 = points.get(i + 1);
              CGLine(p1.x, p1.y, p2.x, p2.y);
          }
      }
  }

public class Line implements Shape {
    Vector point1;
    Vector point2;
    float shapeStrokeWeight;
    public Line() {
    };

    public Line(Vector v1, Vector v2, float sw) {
        point1 = v1;
        point2 = v2;
        shapeStrokeWeight = sw;
    }

    @Override
    public void drawShape() {
        strokeWeight(shapeStrokeWeight);
        CGLine(point1.x, point1.y, point2.x, point2.y);
    }

}

public class Circle implements Shape {
    Vector center;
    float radius;
    float shapeStrokeWeight;
    public Circle() {
    }

    public Circle(Vector v1, float r, float sw) {
        center = v1;
        radius = r;
        shapeStrokeWeight = sw;
    }

    @Override
    public void drawShape() {
        strokeWeight(shapeStrokeWeight);
        CGCircle(center.x, center.y, radius);
    }
}

public class Polygon implements Shape {
    ArrayList<Vector> verties = new ArrayList<Vector>();
    float shapeStrokeWeight;
    public Polygon(ArrayList<Vector> v, float sw) {
        verties = v;
        shapeStrokeWeight = sw;
    }

    @Override
    public void drawShape() {
        if (verties.size() <= 0)
            return;
        for (int i = 0; i <= verties.size(); i++) {
            strokeWeight(shapeStrokeWeight);
            Vector p1 = verties.get(i % verties.size());
            Vector p2 = verties.get((i + 1) % verties.size());
            CGLine(p1.x, p1.y, p2.x, p2.y);
        }
    }
}

public class Ellipse implements Shape {
    Vector center;
    float radius1, radius2;
    float shapeStrokeWeight;
    public Ellipse() {
    }

    public Ellipse(Vector cen, float r1, float r2, float sw) {
        shapeStrokeWeight = sw;
        center = cen;
        radius1 = r1;
        radius2 = r2;
    }

    @Override
    public void drawShape() {
        strokeWeight(shapeStrokeWeight);
        CGEllipse(center.x, center.y, radius1, radius2);
    }
}

public class Curve implements Shape {
    Vector cpoint1, cpoint2, cpoint3, cpoint4;
    float radius1, radius2;
    float shapeStrokeWeight;
    public Curve() {
    }

    public Curve(Vector p1, Vector p2, Vector p3, Vector p4, float sw) {
        shapeStrokeWeight = sw;
        cpoint1 = p1;
        cpoint2 = p2;
        cpoint3 = p3;
        cpoint4 = p4;
    }

    @Override
    public void drawShape() {
        strokeWeight(shapeStrokeWeight);
        CGCurve(cpoint1, cpoint2, cpoint3, cpoint4);
    }
}

public class EraseArea implements Shape {
    Vector point1, point2;
    float shapeStrokeWeight;
    public EraseArea() {
    }

    public EraseArea(Vector p1, Vector p2, float sw) {
        shapeStrokeWeight = sw;
        point1 = p1;
        point2 = p2;
    }

    @Override
    public void drawShape() {
        strokeWeight(shapeStrokeWeight);
        CGEraser(point1, point2);
    }
}
