Intro To Computer Graphics Final Exam


Graphical enhancement of super mario world

<img width="347" alt="image" src="https://github.com/user-attachments/assets/3d19cfb3-4bb4-4dc0-96f2-e46db0e020d5">


In this scene I used A hologram shader, a colour correction post process shader, A toon shader, and a scrolling texture, as well as a rim shader. Each of these shaders have been customized for this exam. 

I decided that the best way to show this graphical enhancement was to recreate the first part of a level in super mario world. 

The player has the ability to move around in the level. I chose to do this as i felt it was a better and more dynamic way of showing off the shaders created for this exam. 

I will now break down where each element was implemented, how it was implemented, why it was implemented, and how it was changed.


**Hologram:**

The hologram shader was used to show objects in the backround of the scene, I wanted to make sure that the background was interesting but not too distracting, So I used the hologram shader to achieve this. This shader was changed to allow it to accept textures and have the hologram shader affect the textures. 


This was done by multiplying the colour of the object by the texture. 

The way the hologram texture works is by finding the rim of the object, this is done getting the normals of the object and the view direction of the camera, and scaling the alpha by the dot product, so that it makes the middle of the object dissapear while brightning the edges by increasing the emission. 

In code it would be 

fixed4 c =  tex2D(_MainTex,IN.uv_MainTex);

o.Albedo = c.rgb + _RimColor.rgb;


half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));

o.Emission = _RimColor.rgb * pow(rim, _RimPower) * 50 * _RimIntensity;

o.Alpha = pow(rim, _RimPower); 

Diagram:









**Colour correction:**


I used colour correction on my scene to better replicate to look and visual style of super mario world. I created a custom LUT for the scene that darkened the entire scene and increased the contrast of certain objects so that they would stand out more. 
                
<img width="512" alt="image" src="https://github.com/user-attachments/assets/c750fd00-3399-48e3-b50c-06c55272c92a">



There is a clear visual difference that can be seen when the colour correction is on and when it is off. 

(With colour correction off)

<img width="345" alt="image" src="https://github.com/user-attachments/assets/20e52d5a-9f21-4441-89f0-f9a99705f4f3">



(With Colour Correction on)

<img width="347" alt="image" src="https://github.com/user-attachments/assets/3d19cfb3-4bb4-4dc0-96f2-e46db0e020d5">


This colour correction shader works by calculating the scene colour offset and saturation by the values shown in the LUT. 
It takes the scene colour based off of the screen position, and changes the colour of each pixel based off of the data given in the LUT. 


float maxColor = COLORS - 1.0;

fixed4 col = saturate(tex2D(_MainTex, i.uv));

float halfColX = 0.5 / _LUT_TexelSize.z;

float halfColY = 0.5 / _LUT_TexelSize.w;

float threshold = maxColor / COLORS;

float xOffset = halfColX + col.r * threshold /
COLORS;

float yOffset = halfColY + col.g * threshold;

float cell = floor(col.b * maxColor);

float2 lutPos = float2(cell / COLORS + xOffset,
yOffset);

float4 gradedCol = tex2D(_LUT, lutPos);

return lerp(col, gradedCol, _Contribution);



**Toon Shading:**


The Toon shader was used in 3 different places, The Ground, The player, and one of the blocks. 

The toon shader was used to replicate a 2D style with the 3D objects in the scene. I wanted to keep the look of the game similar to a 2D game while still allowing the benefits of a 3D project. This toon shader has been changed to allow the object to be affected by textures while still Applying the lighting changes affected by the Custom ramp that I Created. 

The toon shader works by changing how unity assigns the brightness value of pixels on an object. By default, this is done with a gradinent, where the brightness of each pixel slowly decreases as the light affecting it decreases. With toon shading, the brightness value of each pixel is affected by The toon ramp provided and the light direction. For example in my scene the toon ramp is split into 3 different sections, each with a different brightness. The shader takes this toon ramp and applies it to the object, changing how light affects it. 

float diff  = dot (s.Normal, lightDir);

 float h = diff * 0.5 + 0.5;
 
 float2 rh = h;
 
 float3 ramp = tex2D(_RampTex, rh).rgb;

 float4 c;
 
 c.rgb = s.Albedo * _LightColor0.rgb * (ramp);
 
 c.a = s.Alpha;
 
 return c;



(toon ramp used in this project)

![toon ramp](https://github.com/user-attachments/assets/a6862646-6221-4ddc-a7dd-e8c6ee0d72d5)


**Scrolling Texture:**


For the scrolling texture, I used it as a background element to have a more dynamic skybox, instead of just a still image in the background, it will move over time.
The scrolling texture works by changing the vector2 position of the texture on the object by _Time, a built in unity function. 

_ScrollX *= _Time;

_ScrollY *= _Time;

float2 newuv = IN.uv_MainTex + float2 (_ScrollX, _ScrollY);

float4 c = tex2D(_MainTex, newuv);

float3 water = (tex2D (_MainTex, IN.uv_MainTex + float2(_ScrollX, _ScrollY))).rgb;



