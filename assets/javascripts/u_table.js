$(document).ready(function() {
	
	var faqTab = $('.faq-row-handle'),
        faqTabContainer = $('.faq-row-container');
	
	if(faqTab.length){
	
		faqTab.off('click').on('click', function(){
			var faqRow = $(this).parent(),
			    faqContent = $(this).parent().find('.faq-row-content');
            
			    faqTabContainer.find('.faq-row-content').not(faqContent).stop().slideUp('slow');
                faqTabContainer.find('.faq-row').not(faqRow).removeClass('open');
                
			    faqContent.stop().slideToggle('slow', function() {
					faqRow.toggleClass('open', faqContent.is(':visible'));
				});
		});
		
	}
	


//var x = 1;
//var x=0;
//function rotate() {
//	if(x==0)
	// { ()

		// x=1;
	// }else{
// 
		// x=0;
	// }
	
    // $(this).css("-moz-transform", "rotate(" + angle + "deg)");
    // x++;    
    // if (x > 2) x = 0;
// } 
      
// $("#b-arrow").click(rotate);



// function changeImage() {

// //its checking C:\Users\ws21\Desktop\images\arrowd_n.png=="images\arrowup_n.png"
//         if  (document.getElementById("b-arrow").src == "images/arrowup_n.png")
//         {
//             document.getElementById("b-arrow").src = "images/arrowd_n.png";
//         }
//         else 
//         {
//             document.getElementById("b-arrow").src = "images/arrowup_n.png";
//         }

//     }

//     $("#b-arrow").click(changeImage);

});

