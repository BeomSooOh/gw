package neos.cmm.util;

import java.awt.AlphaComposite;
import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.RenderingHints;
import java.awt.Toolkit;
import java.awt.image.BufferedImage;
import java.awt.image.FilteredImageSource;
import java.awt.image.ImageFilter;
import java.awt.image.ImageProducer;
import java.awt.image.RGBImageFilter;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;

import javax.imageio.ImageIO;

import org.apache.commons.io.IOUtils;
import org.apache.sanselan.ImageReadException;

/**
 * image 관련 util
 * @author yongil
 *
 */
public class ImageUtil {
	
	public static void saveCropImage(File f, File oriFile, int width, int rate) {
		FileOutputStream fos = null;
		FileInputStream fio = null;
		try {
			fio = new FileInputStream(oriFile);
			byte[] b = IOUtils.toByteArray(fio);
			
			fos = new FileOutputStream(f);
// sh_modi_20220906 emp_seq에 .이 포함된 경우 thumnail 파일이 생성되지 않는 오류수정을 위하여 수정 
//			fos.write(ImageUtil.getCropImage(b, width, rate, 
//					f.getName().substring(f.getName().indexOf(".")+1)));
			fos.write(ImageUtil.getCropImage(b, width, rate, 
					f.getName().substring(f.getName().lastIndexOf(".")+1)));
			
		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		} finally {
			if (fos != null) {
				try {
					fos.close();
				} catch (IOException e) {
					CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				}
			}
			if (fio != null) {
				try {
					fio.close();
				} catch (IOException e) {
					CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				}
			}
		}
	}
	
	
	/**
	 * image crop
	 * @param imageContent
	 * @param maxWidth
	 * @param xyRatio
	 * @return
	 * @throws IOException
	 */
	public static byte[] getCropImage( byte[] imageContent, int maxWidth, double xyRatio, String ext) throws IOException {

        BufferedImage originalImg = ImageIO.read( new ByteArrayInputStream(imageContent));

 

        //get the center point for crop

        int[] centerPoint = { originalImg.getWidth() /2, originalImg.getHeight() / 2 };

 

        //calculate crop area

        int cropWidth=originalImg.getWidth();

        int cropHeight=originalImg.getHeight();

 

        if( cropHeight > cropWidth * xyRatio ) {

            //long image

            cropHeight = (int) (cropWidth * xyRatio);

        } else {

            //wide image

            cropWidth = (int) ( (float) cropHeight / xyRatio) ;

        }

 

        //set target image size

        int targetWidth = cropWidth;

        int targetHeight = cropHeight;

 

        if( targetWidth > maxWidth) {

            //too big image

            targetWidth = maxWidth;

//            targetHeight = (int) (targetWidth * xyRatio);

        } 

 

        //processing image

        BufferedImage targetImage = new BufferedImage(targetWidth, targetHeight, BufferedImage.TYPE_INT_RGB);

        Graphics2D graphics2D = targetImage.createGraphics();

        graphics2D.setBackground(Color.WHITE);

        graphics2D.setPaint(Color.WHITE);

        graphics2D.fillRect(0, 0, targetWidth, targetHeight);

        graphics2D.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BILINEAR);

        graphics2D.drawImage(originalImg, 0, 0, targetWidth, targetHeight,   centerPoint[0] - (int)(cropWidth /2) , centerPoint[1] - (int)(cropHeight /2), centerPoint[0] + (int)(cropWidth /2), centerPoint[1] + (int)(cropHeight /2), null);

 

        ByteArrayOutputStream output = new ByteArrayOutputStream();

        ImageIO.write(targetImage, ext, output);

 

        return output.toByteArray();

    }
	
	
	public static void saveResizeImage(File f, File oriFile, int width) {
		FileOutputStream fos = null;
		FileInputStream fio = null;
		try {
			fio = new FileInputStream(oriFile);
			byte[] b = IOUtils.toByteArray(fio);
			
			fos = new FileOutputStream(f);
				
				byte[] resizeImage = null;
				
				try {
// sh_modi_20220906 emp_seq에 .이 포함된 경우 thumnail 파일이 생성되지 않는 오류수정을 위하여 수정 
//					resizeImage = ImageUtil.resizeImage(b, width,width, true, false, f.getName().substring(f.getName().indexOf(".")+1));
					resizeImage = ImageUtil.resizeImage(b, width,width, true, false, f.getName().substring(f.getName().lastIndexOf(".")+1));
				} catch (IOException ioe) {
					// sh_modi_20220906 emp_seq에 .이 포함된 경우 thumnail 파일이 생성되지 않는 오류수정을 위하여 수정 
//					resizeImage = ImageUtil.resizeImageCMYK(oriFile, width,width, true, false, f.getName().substring(f.getName().indexOf(".")+1));
					resizeImage = ImageUtil.resizeImageCMYK(oriFile, width,width, true, false, f.getName().substring(f.getName().lastIndexOf(".")+1));

				}

				fos.write(resizeImage);
			
		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		} finally {
			if (fos != null) {
				try {
					fos.close();
				} catch (IOException e) {
					CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				}
			}
			if (fio != null) {
				try {
					fio.close();
				} catch (IOException e) {
					CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				}
			}
		}
	}
	//제거되지 않고 남은 디버그 코드
//	public static void main(String[] args) throws IOException {
//
//        String imgUrl = "http://wstatic.dcinside.com/new/interview/dc_se1.jpg";
//
//        // width: height
//
//        URL url = new URL(imgUrl);
//        File f = new File("d:/a.jpg");
//        FileOutputStream fos = new FileOutputStream(f);
//        fos.write(ImageUtil.getCropImage( getImageContent(url), 420, 1, "jpg"));
//        fos.close();
//
// 
//
//    }
	
	public static byte[] getImageContent(URL url) throws IOException {

	        ByteArrayOutputStream bais = new ByteArrayOutputStream();

	        InputStream is = null;

	 

	          is = url.openStream ();

	          byte[] byteChunk = new byte[4096]; // Or whatever size you want to read in at a time.

	          int n;

	 

	          while ( (n = is.read(byteChunk)) > 0 ) {

	            bais.write(byteChunk, 0, n);

	          }

	 

	        is.close();

	        return bais.toByteArray();

	    }

	 
	 /**
		 * 이미지 리사이즈
		 * 
		 * @param imageContent 이미지 객체
		 * @param newWidth 섬네일 이미지 가로 사이즈 px
		 * @param newHeight 섬네일 이미지 세로 사이즈 px
		 * @param isWidthResize 세로 사이즈 비율조정 여부 (true일 경우 newWidth에 따라 이미지 비율 조정)
		 * @param isFillSpace 리사이즈된 섬네일 상하좌우 여백을 채울지 여부
		 * @param ext 이미지 파일 확장자
		 * @return 섬네일 이미지명
		 * @throws Exception
		 */
	 public static  byte[] resizeImage( byte[] imageContent, int newWidth, int newHeight, boolean isWidthResize, boolean isFillSpace, String ext) throws IOException {

		 BufferedImage image = ImageIO.read( new ByteArrayInputStream(imageContent));

		 return resizeImage(image, newWidth, newHeight, isWidthResize, isFillSpace, ext);
	 }
	 
	 public static  byte[] resizeImage( BufferedImage image, int newWidth, int newHeight, boolean isWidthResize, boolean isFillSpace, String ext) throws IOException {
		 ByteArrayOutputStream output = new ByteArrayOutputStream();

		 int imageWidth = image.getWidth();
		 int imageHeight = image.getHeight();

		 int thumbWidth = imageWidth;
		 int thumbHeight = imageHeight;

		 if( thumbHeight > newHeight) {
			 thumbWidth = (int)(thumbWidth * ((double)newHeight / (double)thumbHeight));
			 thumbHeight = newHeight;
		 }

		 if(isWidthResize && imageWidth > newWidth) {
			 thumbWidth = newWidth;
			 thumbHeight = (int)(imageHeight * ((double)newWidth / (double)imageWidth));
		 } 
		 
		 // 리사이즈 하려는 크기보다 작을경우

		 int canvasWidth = thumbWidth;
		 int canvasHeight = thumbHeight;
		 int canvasX = 0;
		 int canvasY = 0;

		 if(isFillSpace) {
			 canvasWidth = newWidth;
			 canvasHeight = newHeight;
			 canvasX = (canvasWidth - thumbWidth) / 2;
			 canvasY = (canvasHeight - thumbHeight) / 2;
		 }

		 // 사이즈 확인용
//		 System.out.println("newWidth :" + newWidth);
//		 System.out.println("newHeight :" + newHeight);
//		 System.out.println("imageWidth :" + imageWidth);
//		 System.out.println("imageHeight :" + imageHeight);           
//		 System.out.println("thumbWidth :" + thumbWidth);
//		 System.out.println("thumbHeight :" + thumbHeight);
//		 System.out.println("canvasWidth :" + canvasWidth);
//		 System.out.println("canvasHeight :" + canvasHeight);
//		 System.out.println("canvasX :" + canvasX);
//		 System.out.println("canvasY :" + canvasY);

		 BufferedImage returnImage = null;
		 
		 /** 이미지 투명작업 */
		 if(ext.toLowerCase().equals("png")) {
			 BufferedImage intermediateImage = new BufferedImage(canvasWidth, canvasHeight, BufferedImage.TYPE_INT_RGB);
			 Graphics2D gi = intermediateImage.createGraphics();
			 gi.setComposite(AlphaComposite.SrcOver);
			 gi.setColor(Color.WHITE);
			 gi.fillRect(0, 0, imageWidth, imageHeight);
			 gi.drawImage(image, canvasX, canvasY, thumbWidth, thumbHeight, Color.WHITE, null);
			 gi.dispose();

			 //if image from db already had a transparent background, it becomes black when drawing it onto another
			 //even if we draw it onto a transparent image
			 //so we set it to a specific color, in this case white
			 //now we have to set that white background transparent
			 Image intermediateWithTransparentPixels = makeColorTransparent(intermediateImage, Color.WHITE);

			 //finalize the transparent image
			 returnImage = new BufferedImage(thumbWidth, thumbHeight, BufferedImage.TYPE_INT_ARGB);
			 Graphics2D gf = returnImage.createGraphics();
			 gf.setComposite(AlphaComposite.SrcOver);
			 gf.setColor(new Color(0, 0, 0, 0));
			 gf.fillRect(0, 0, thumbWidth, thumbHeight);
			 gf.drawImage(intermediateWithTransparentPixels, 0, 0, thumbWidth, thumbHeight, new Color(0, 0, 0, 0), null);
			 gf.dispose();
		 
		 } else {
			 returnImage = new BufferedImage(canvasWidth, canvasHeight, BufferedImage.TYPE_INT_RGB);
			 Graphics2D graphics2D = returnImage.createGraphics();
			 graphics2D.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BILINEAR);
			 graphics2D.setBackground(Color.BLACK);
			 graphics2D.clearRect(0, 0, canvasWidth, canvasHeight);
			 graphics2D.drawImage(image, canvasX, canvasY, thumbWidth, thumbHeight, null);
		 }
		 
		 ImageIO.write(returnImage, ext, output);

		 return output.toByteArray();
	 }
	 
	 public static  byte[]  resizeImageCMYK(File file, int newWidth, int newHeight, boolean isWidthResize, boolean isFillSpace, String ext) throws IOException, ImageReadException {

		 JpegReader jpegReader = new JpegReader();
		 
		 BufferedImage image = jpegReader.readImage(file);
		 
		 return resizeImage(image, newWidth, newHeight, isWidthResize, isFillSpace, ext);
		 
	 }

	 
	 public static Image makeColorTransparent(Image im, final Color color) {
		    ImageFilter filter = new RGBImageFilter() {
		        // the color we are looking for... Alpha bits are set to opaque
		        public int markerRGB = color.getRGB() | 0xFF000000;

		        public final int filterRGB(int x, int y, int rgb) {
		            if ((rgb | 0xFF000000) == markerRGB) {
		                // Mark the alpha bits as zero - transparent
		                return 0x00FFFFFF & rgb;
		            } else {
		                // nothing to do
		                return rgb;
		            }
		        }
		    };

		    ImageProducer ip = new FilteredImageSource(im.getSource(), filter);
		    return Toolkit.getDefaultToolkit().createImage(ip);
		}

}
