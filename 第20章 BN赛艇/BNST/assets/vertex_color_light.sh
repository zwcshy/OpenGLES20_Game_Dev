uniform mat4 uMVPMatrix; //总变换矩阵
const vec3 uCamera=vec3(-1.0,3.0,0.0);	//摄像机位置
attribute vec3 aPosition;  //顶点位置
attribute vec3 aNormal;    //顶点法向量
//用于传递给片元着色器的变量
varying vec4 ambient;
varying vec4 diffuse;
varying vec4 specular;

//定位光光照计算的方法
void pointLight
(
  in vec3 normal,//法向量
  inout vec4 ambient,//环境光分量
  inout vec4 diffuse,//散射光分量
  inout vec4 specular,//镜面反射光分量  
  in vec3 uCamera,	//光源位置
  in vec4 lightAmbient,//光的环境光分量
  in vec4 lightDiffuse,//光的散射光分量
  in vec4 lightSpecular//光的镜面反射光分量
)
{
  
  vec3 newNormal=normal;
  
  //计算从表面点到摄像机的矢量
  vec3 eye= normalize(uCamera-aPosition);
  
  //光源位置
  vec3 lLocation=uCamera;
  
  //计算从表面点到光源位置的矢量
  vec3 vp= normalize(lLocation-aPosition);
  //计算表面点和光源位置的距离
  float d=length(vp);
  //格式化vp
  vp=normalize(vp);
  vec3 halfVector=normalize(vp+eye);//光最亮方向
  
  float shininess=100.0;//粗糙度，越小越光滑
  
  float nDotViewPosition;//法线与光方向的点积
  float nDotViewHalfVector;//法线与光最亮方向的点积
  float powerFactor;//镜面反射光幂因子
  
  nDotViewPosition=max(0.0,dot(newNormal,vp));
  nDotViewHalfVector=max(0.0,dot(newNormal,halfVector));
  
  if(nDotViewPosition==0.0)
  {
     powerFactor=0.0;
  }
  else
  {
     powerFactor=pow(nDotViewHalfVector,shininess);
  }
  
  ambient+=lightAmbient;
  diffuse+=lightDiffuse*nDotViewPosition;
  specular=lightSpecular*powerFactor;  
}


void main()       
{ 
   gl_Position = uMVPMatrix * vec4(aPosition,1); //根据总变换矩阵计算此次绘制此顶点位置  
   
   vec4 ambientTemp=vec4(0.0,0.0,0.0,0.0);
   vec4 diffuseTemp=vec4(0.0,0.0,0.0,0.0);
   vec4 specularTemp=vec4(0.0,0.0,0.0,0.0);
   
   pointLight(normalize(aNormal),ambientTemp,diffuseTemp,specularTemp,uCamera,vec4(0.5,0.5,0.5,1.0),vec4(0.7,0.7,0.7,1.0),vec4(0.3,0.3,0.3,1.0));
   
   ambient=ambientTemp;
   diffuse=diffuseTemp;
   specular=specularTemp;
}                      