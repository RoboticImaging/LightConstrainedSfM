function [mv_x, mv_y, m_search, CI, error] = getMin(Rimg, Aimg, B, BL, SRStart, SREnd, pix)

    if nargin < 7
        pix = 1; %pixel level, sub-pixel or good
    end

m_search = 0;
ly = BL(1);
lx = BL(2);
Rtile = Rimg(ly:ly+B-1,lx:lx+B-1);
     
mv_x=0;
mv_y=0;

error = 1e60;
 
%Find the minimum error producing tile within the search area and associate that specific tile for that specific pixel search.
  for y = SRStart(1):SREnd(1)-pix*B+1
    for x = SRStart(2):SREnd(2)-pix*B+1
        
      Alttile = Aimg(y:pix:(y+pix*B-1),x:pix:(x+pix*B-1));
      E = abs(Rtile(:)-Alttile(:));
      
      t_error = sum(E.^2);
      m_search = m_search+1;
      
      if t_error < error
           error = t_error;
           mv_x = x/pix-lx;
           mv_y = y/pix-ly;
           CI = Alttile;

      end
    end
 end

end
