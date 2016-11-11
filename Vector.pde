// vectors are 2 dimensional and have addition,subtraction,scalarmult, and a distance formula 
class Vector 
  {
    float x=0.0;
    float y=0.0;
 
    
    Vector(float _x, float _y)
      {
        x = _x;
        y = _y;
      } 
    
    Vector addition(Vector a, Vector b)
      {
        return new Vector(a.x+b.x,a.y+b.y);  
      }
      
    Vector subtraction(Vector a, Vector b)
      {
        return new Vector(a.x-b.x,a.y-b.y);  
      }  
      
    float distance(Vector a, Vector b) 
      {
        float dist = sqrt(pow(a.x-b.x,2)+pow(a.y-b.y,2)); 
        return dist;  
      }
      
    Vector scalarmult(float a, Vector b)
      {
        b.x= a*b.x;
        b.y= a*b.y;
        return b;
      }  
  
    }