title: BREW中几种常用的效果（淡淡浅出、半透明）
description:
category: Brew
tag: Brew Bitmap FadeIn FadeOut
-------------------------

> 网络摘抄 版权申明见：http://yarin.iteye.com/blog/453262

```c
/*****************************************************
  Function:FadeIn
  Desc:从0增加R,G,B颜色值，实现淡入效果
 Input:pDst-目标位图,16位色，xdst,ydst－目标位图位置,pSrc-源位图，16位色，width,height-源位图大小,必须确保ydst+height<pDst>Height,xdst+width<pDst->Width,
   step-步长
  Output:pDst-经过处理的位图
  Return:
*****************************************************/
void FadeIn(IBitmap *pDst,int xdst,int ydst,IBitmap *pSrc,int width,int height,int step)
{
  int x,y;
  int offset1,offset2;
  int offdst;
  int offsrc;
  uint16 dstcolor,srccolor;
  uint8 r,g,b;

  IDIB *dstdib = (IDIB*)pDst;
  IDIB *srcdib = (IDIB*)pSrc;

  // 获得实际的图片点阵数据
  uint16 *pDstBmp = (uint16*)dstdib->pBmp;
  uint16 *pSrcBmp=(uint16 *)srcdib->pBmp;

  if(dstdib->nDepth!=16 || srcdib->nDepth!=16)
    return;
	// 一般手机屏幕都是16位，565格式
	if(dstdib->nColorScheme == IDIB_COLORSCHEME_565)
	{
    offset1=((ydst*dstdib->nPitch)>>1)+xdst;
    offset2=0;
    for(y=0;y<height;y++)
    {
      offdst=offset1;
      offsrc=offset2;
      for(x=0;x<width;x++)
      {
        dstcolor=pDstBmp[offdst];
        srccolor=pSrcBmp[offsrc];
        if(srccolor!=63519)
        {
          r=srccolor>>11;
          g=(srccolor>>5) & 0x3f;
          b=srccolor & 0x1f;
          if(step<r)
            r=step;
          if(step<g)
            g=step;
          if(step<b)
            b=step;
          pDstBmp[offdst]=r<<11 | g<<5 | b;
        }
        offsrc++;
        offdst++;
      }
      offset1+=(dstdib->nPitch>>1);
      offset2+=(srcdib->nPitch>>1);
    }
  }
}

/*****************************************************
  Function:Alpha256Bmp
  Desc:256色位图alpha混合，修改调色板，只适用256色位图,加快速度用。
 Input:pDst-目标位图，xdst,ydst-位置，width,height-半透明处理位图大小,pSrc-256色位图,xscr,yscr-源位置,R,G,B半透明颜色值,alpha
  Output:
  Return:
******************************************************/
void Alpha256Bmp(IBitmap *pDst,int xdst,int ydst,int width,int height,IBitmap *pSrc,
                 int xsrc,int ysrc,uint8 r, uint8 g, uint8 b,float alpha)
{
  uint8 dstcolor;
  uint32 *pPalette;
  uint32 *pBackup;
  byte   *pOrigBytes;
  byte   *pNowBytes;
  int    i;

  IDIB *srcdib = (IDIB*)pSrc;
  if(srcdib->nColorScheme>0)
    return;
  if(srcdib->cntRGB==0)
    return;
  pPalette=(uint32*)MALLOC(sizeof(uint32)*255);
  pNowBytes=(byte*)pPalette;
  pOrigBytes=(byte *)srcdib->pRGB;
  pBackup=srcdib->pRGB;
  for(i=0;i<srcdib->cntRGB;i++)
  {
    dstcolor=(*pOrigBytes++);
    dstcolor=(uint8)(dstcolor+(alpha*(r-dstcolor)));
    *pNowBytes++=dstcolor;
    dstcolor=(*pOrigBytes++);
    dstcolor=(uint8)(dstcolor+(alpha*(g-dstcolor)));
    *pNowBytes++=dstcolor;
    dstcolor=(*pOrigBytes++);
    dstcolor=(uint8)(dstcolor+(alpha*(b-dstcolor)));
    *pNowBytes++=dstcolor;
    pNowBytes++;
    pOrigBytes++;
  }
  srcdib->pRGB=pPalette;
  IBITMAP_BltIn(pDst,xdst,ydst,width,height,pSrc,xsrc,ysrc,AEE_RO_COPY);
  srcdib->pRGB=pBackup;
  FREE(pPalette);
}

/*****************************************************
  Function:SpecialAlpha256Bmp
  Desc:256色位图alpha混合，修改调色板，只适用256色位图,加快速度用。
 Input:pDst-目标位图，xdst,ydst-位置，width,height-半透明处理位图大小,
        pSrc-256色位图,xscr,yscr-源位置,R,G,B半透明颜色值,alpha
  Output:
  Return:
******************************************************/
void SpecialAlpha256Bmp(IBitmap *pDst,int xdst,int ydst,int width,int height,IBitmap *pSrc,
                 int xsrc,int ysrc,uint8 r, uint8 g, uint8 b)
{
  uint8 dstcolor;
  uint32 *pPalette;
  uint32 *pBackup;
  byte   *pOrigBytes;
  byte   *pNowBytes;
  int    i;

  IDIB *srcdib = (IDIB*)pSrc;
  if(srcdib->nColorScheme>0)
    return;
  if(srcdib->cntRGB==0)
    return;
  pPalette=(uint32*)MALLOC(sizeof(uint32)*255);
  pNowBytes=(byte*)pPalette;
  pOrigBytes=(byte *)srcdib->pRGB;
  pBackup=srcdib->pRGB;
  for(i=0;i<srcdib->cntRGB;i++)
  {
    dstcolor=(*pOrigBytes++);
    dstcolor=(uint8)(dstcolor+((r-dstcolor)>>1));
    *pNowBytes++=dstcolor;
    dstcolor=(*pOrigBytes++);
    dstcolor=(uint8)(g>>1);
    *pNowBytes++=dstcolor;
    dstcolor=(*pOrigBytes++);
    dstcolor=(uint8)(b>>1);
    *pNowBytes++=dstcolor;
    pNowBytes++;
    pOrigBytes++;
  }
  srcdib->pRGB=pPalette;
  IBITMAP_BltIn(pDst,xdst,ydst,width,height,pSrc,xsrc,ysrc,AEE_RO_COPY);
  srcdib->pRGB=pBackup;
  FREE(pPalette);
}

/*****************************************************
  Function:SpecialAlpha
  Desc:实现和某种颜色的半透明
 Input:pDst-目标位图,16位色，xdst,ydst－目标位图位置,width,height-半透明处理位图大小,必须确保ydst+height<pDst->Height,xdst+width<pDst->Width,R,G,B半透明颜色值
 Output:pDst-经过处理的位图
 Return:
*****************************************************/
void SpecialAlpha(IBitmap *pDst,int xdst,int ydst,int width,int height,
                 uint8 r, uint8 g, uint8 b)
{
  int x,y;
  int offset1;
  int offdst;
  uint16 dstcolor;
  uint8 dstr,dstg,dstb;

  IDIB *dstdib = (IDIB*)pDst;

  uint16 *pDstBmp = (uint16*)dstdib->pBmp; // 获得实际的图片点阵数据。

  if(dstdib->nDepth!=16)
    return;
  // 一般手机屏幕都是16位，565格式
  r=r & 0x1f;
  g=(g & 0x3f);
  b=b & 0x1f;
	if(dstdib->nColorScheme == IDIB_COLORSCHEME_565)
	{
    offset1=((ydst*dstdib->nPitch)>>1)+xdst;
    for(y=0;y<height;y++)
    {
      if(y==height-1)
        offdst=0;
      offdst=offset1;
      for(x=0;x<width;x++)
      {
        dstcolor=pDstBmp[offdst];
        dstr=dstcolor>>11;
        dstr=(uint8)(dstr+((r-dstr)>>1));
        dstg=(dstcolor>>5) & 0x3f;
        dstg=(uint8)(g>>1);
        dstb=dstcolor & 0x1f;
        dstb=(uint8)(b>>1);
        pDstBmp[offdst]=dstr<<11 | dstg<<5 | dstb;
        offdst++;
      }
      offset1+=(dstdib->nPitch>>1);
    }
  }
}

/*****************************************************
  Function:FastAlpha
  Desc:实现和某种颜色的半透明
 Input:pDst-目标位图,16位色，xdst,ydst－目标位图位置,width,height-半透明处理位图大小,必须确保ydst+height<pDst->Height,xdst+width<pDst->Width,R,G,B半透明颜色值
  Output:pDst-经过处理的位图
  Return:
*****************************************************/
void FastAlpha(IBitmap *pDst,int xdst,int ydst,int width,int height,
                 uint8 r, uint8 g, uint8 b)
{
  int x,y;
  int offset1;
  int offdst;
  uint16 dstcolor;
  uint8 dstr,dstg,dstb;

  IDIB *dstdib = (IDIB*)pDst;
  // 获得实际的图片点阵数据。
  uint16 *pDstBmp = (uint16*)dstdib->pBmp;
  if(dstdib->nDepth!=16)
    return;
 // 一般手机屏幕都是16位，565格式
  r=r & 0x1f;
  g=(g & 0x3f);
  b=b & 0x1f;
	if(dstdib->nColorScheme == IDIB_COLORSCHEME_565)
	{
    offset1=((ydst*dstdib->nPitch)>>1)+xdst;
    for(y=0;y<height;y++)
    {
      if(y==height-1)
        offdst=0;
      offdst=offset1;
      for(x=0;x<width;x++)
      {
        dstcolor=pDstBmp[offdst];
        dstr=dstcolor>>11;
        dstr=(uint8)(dstr+((r-dstr)>>1));
        dstg=(dstcolor>>5) & 0x3f;
        dstg=(uint8)(dstg+((g-dstg)>>1));
        dstb=dstcolor & 0x1f;
        dstb=(uint8)(dstb+((b-dstb)>>1));
        pDstBmp[offdst]=dstr<<11 | dstg<<5 | dstb;
        offdst++;
      }
      offset1+=(dstdib->nPitch>>1);
    }
  }
}

/*****************************************************
  Function:AlphaBlend
  Desc:实现和某种颜色的半透明
 Input:pDst-目标位图,16位色，xdst,ydst－目标位图位置,width,height-半透明处理位图大小,必须确保ydst+height<pDst->Height,xdst+width<pDst->Width,R,G,B半透明颜色值，alpha-半透明因子
  Output:pDst-经过处理的位图
  Return:
*****************************************************/
void AlphaBlend(IBitmap *pDst,int xdst,int ydst,int width,int height,
                 uint8 r, uint8 g, uint8 b,float alpha)
{
  int x,y;
  int offset1;
  int offdst;
  uint16 dstcolor;
  uint8 dstr,dstg,dstb;

  IDIB *dstdib = (IDIB*)pDst;

  uint16 *pDstBmp = (uint16*)dstdib->pBmp;
  if(dstdib->nDepth!=16)
    return;

  r=r & 0x1f;
  g=(g & 0x3f);
  b=b & 0x1f;
	if(dstdib->nColorScheme == IDIB_COLORSCHEME_565)
	{
    offset1=((ydst*dstdib->nPitch)>>1)+xdst;
    for(y=0;y<height;y++)
    {
      if(y==height-1)
        offdst=0;
      offdst=offset1;
      for(x=0;x<width;x++)
      {
        dstcolor=pDstBmp[offdst];
        dstr=dstcolor>>11;
        dstr=(uint8)(dstr+(alpha*(r-dstr)));
        dstg=(dstcolor>>5) & 0x3f;
        dstg=(uint8)(dstg+(alpha*(g-dstg)));
        dstb=dstcolor & 0x1f;
        dstb=(uint8)(dstb+(alpha*(b-dstb)));
        pDstBmp[offdst]=dstr<<11 | dstg<<5 | dstb;
        offdst++;
      }
      offset1+=(dstdib->nPitch>>1);
    }
  }
}

```
