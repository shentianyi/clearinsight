/**
 * Created by marco on 16-7-6.
 */

$(function () {
    $('[data-toggle="tooltip"]').tooltip();
    $('.dropdown-toggle').dropdown();
});

Date.prototype.Format = function (fmt) { //author: meizz
    var o = {
        "M+": this.getMonth() + 1,                 //月份
        "d+": this.getDate(),                    //日
        "h+": this.getHours(),                   //小时
        "m+": this.getMinutes(),                 //分
        "s+": this.getSeconds(),                 //秒
        "q+": Math.floor((this.getMonth() + 3) / 3), //季度
        "S": this.getMilliseconds()             //毫秒
    };
    if (/(y+)/.test(fmt))
        fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o)
        if (new RegExp("(" + k + ")").test(fmt))
            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
};

function FutureDate(day) {
    var now = new Date();
    var FutureDate = new Date(now.getTime() - day * 24 * 60 * 60 * 1000).Format("yyyy/MM/dd");
    return FutureDate;
}

$('.datetime-picker-from').datetimepicker({
    lang: 'ch',
    timepicker: false,
    format: 'Y/m/d H:i',
    formatDate: 'Y/m/d',
    formatTime: 'H:i',
    defaultTime: '00:00'
});

$('.datetime-picker-to').datetimepicker({
    lang: 'ch',
    timepicker: false,
    format: 'Y/m/d H:i',
    formatDate: 'Y/m/d',
    formatTime: 'H:i',
    defaultTime: '23:59'
});

if ($('#notice').val()) {
    $('#notice').notifyModal();
}
