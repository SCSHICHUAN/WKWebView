
if (navigator.onLine){
    netChange('网络连接');
} else {
    netChange('网络断开');
};

window.ononline = function() {
    netChange('网络连接');
};
window.onoffline = function(){
    netChange('网络断开');
};
function netChange(msg){
    window.webkit.messageHandlers.jsToOcWithPramsNet.postMessage({'params':msg});
}
