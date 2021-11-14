//= require nested_fields
//= require simplemde/dist/simplemde.min.js


$(function(){
    var click_menu = false;
    $('.smartphone-menu-button').click(function(){
        console.log("aaaaaaaaaaa")
        if(!click_menu){
            $('.smartphone-menu-box').addClass("dis");
            $('.smartphone-menu-button').addClass("dis");
            $('.background-modal-menu-click-box').addClass("dis");
            // $('.header-top-box').addClass("dis");
            click_menu = true;
        }else{
            $('.smartphone-menu-box').removeClass("dis");
            $('.smartphone-menu-button').removeClass("dis");
            $('.background-modal-menu-click-box').removeClass("dis");
            // $('.header-top-box').removeClass("dis");
            click_menu = false;
        }
    });
})
function createPngFileBase64(base64, name){
    var bin = atob(base64.replace(/^.*,/, ''));
    var buffer = new Uint8Array(bin.length);
    for(var i = 0; i < bin.length; i++){
        buffer[i] = bin.charCodeAt(i);
    }
    return new File([buffer.buffer], name, {type: "image/png"});
}
function createUrlToBase64(url, callback){
    var xhr = new XMLHttpRequest();
    xhr.onload = function() {
      var reader = new FileReader();
      reader.onloadend = function() {
        callback(reader.result);
      }
      reader.readAsDataURL(xhr.response);
    };
    xhr.open('GET', url);
    xhr.responseType = 'blob';
    xhr.send();
}
function $get_id(name){
    return document.getElementById(name);
}

function $get_class(name){
    return document.getElementsByClassName(name);
}

function $get_tag_name(name){
    return document.getElementsByTagName(name);
}

function child_all_destroy(element){
    //子要素をすべて削除する関数
    var target = element;
    while(target.firstChild){
        target.removeChild(target.firstChild)
    }
}