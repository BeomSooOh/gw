//<![CDATA[
    $(document).ready(function() {
        var p = $('div.boardBox > div>h2');
        $('div.boardBox > div').click(
		        function() {
		            var t = $(this);
		            var idx = $(this).index();
		            t.parent()[0].className = 'boardBox board' + (idx + 1);

		            for (var i = 0; i <= p.length - 1; i++)
		            {
		                 $('#board' + (i + 1)).hide();
		            }
		            
		            $('#board' + (idx + 1)).show();
		        }
	        );
    });
 //]]> 



jQuery(function($){
	// Faced Tab Navigation
	var tab_face = $('div.tab.face');
	var tab_face_i = tab_face.find('>ol>li');
	var tab_face_ii = tab_face.find('>ol>li>ol>li');
	tab_face.removeClass('jx');
	tab_face_i.find('>ol').hide();
	tab_face_i.find('>ol>li[class=active]').parents('li').attr('class','active');
	tab_face.find('>ol>li[class=active]').find('>ol').show();
	function faceTabMenuToggle(event){
		var t = $(this);
		tab_face_i.find('>ol').hide();
		t.next('ol').show();
		tab_face_i.removeClass('active');
		t.parent('li').addClass('active');
		return false;
	}
	function faceTabSubMenuActive(){
		tab_face_ii.removeClass('active');
		$(this).parent(tab_face_ii).addClass('active');
		return false;
	}; 
	tab_face_i.find('>a[href=#]').click(faceTabMenuToggle).focus(faceTabMenuToggle);
	tab_face_ii.find('>a[href=#]').click(faceTabSubMenuActive).focus(faceTabSubMenuActive);
});