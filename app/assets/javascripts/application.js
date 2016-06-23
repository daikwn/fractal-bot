window.addEventListener("load", init, false);
 
function init()
{
    var theCanvas = document.getElementById("canvas");
    var centerX = (theCanvas.currentStyle || document.defaultView.getComputedStyle(theCanvas,'')).width;
    centerX = Number(centerX.replace('px',''));
    centerX = 25;
    var centerY = (theCanvas.currentStyle || document.defaultView.getComputedStyle(theCanvas,'')).height;
    centerY = Number(centerY.replace('px',''));
    centerY =  centerY / 2;
    var ctx = theCanvas.getContext("2d");
     
    var X = 0;
    var Y = 0;
    var nowX = 0;
    var nowY = 0;
    var nowD = 0;
    var trees1 = new Array();
    var trees2 = new Array();
     
    trees1.push(0, -88, 176, -88);
    trees2.push(0.28, 0.28, 0.28, 0.7);
    fractal(420);
    
    var img_png_src = theCanvas.toDataURL();
    document.getElementById("image_png").src = img_png_src;
    document.getElementById("data_url_png").firstChild.nodeValue = img_png_src;
     
    function directionChange(degree)
    {
        nowD = nowD + degree;
    }
     
    function process(length)
    {
        X = nowX + length * Math.cos(nowD * Math.PI / 180);
        Y = nowY + length * Math.sin(nowD * Math.PI / 180);
         
        ctx.lineWidth = 1;
        ctx.strokeStyle = '#000000';
        ctx.beginPath();
        ctx.moveTo(centerX + nowX, centerY + nowY);
        ctx.lineTo(centerX + X, centerY + Y);
        ctx.stroke();
        ctx.closePath();
         
        nowX = X;
        nowY = Y;
         
    }
         
    function fractal(length)
    {
        if (length <= 2)
        {
            process(length);
        }
        else
        {
            for (var i = 0; i < 4; i++)
            {
                directionChange(trees1[i]);
                fractal(length * trees2[i]);
            }
        }
    }
}