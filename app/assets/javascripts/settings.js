/**
 * Created by marco on 16-8-1.
 */

var Settings = {};

Settings.init = function () {
    $(document).on('mouseenter', '.kpi-target', function () {
        $(this).find('.kpi-target-remove').fadeIn();
        Settings.remove_target();
    });

    $(document).on('mouseleave', '.kpi-target', function () {
        $(this).find('.kpi-target-remove').fadeOut();
    });
};

Settings.add_target = function (kpi) {
    /*Setting_Item */
    if (kpi.hasOwnProperty("setting_items") && kpi.setting_items.length > 0) {
        var SettingItemsHtml = "";
        for (var i = 0; i < kpi.setting_items.length; i++) {
            SettingItemsHtml += '<div class=" col-lg-4 col-md-4 col-sm-6 col-xs-12"><div class="input-group">' +
                '<span class="input-group-addon" name="' + kpi.setting_items[i].field_name + '" id="' + kpi.setting_items[i].id + '">' + kpi.setting_items[i].name + '(' + kpi.setting_items[i].field_unit_string + ')</span>' +
                '<input type="text" class="form-control" value="' + kpi.setting_items[i].field_value + '" aria-describedby="' + kpi.setting_items[i].id + '">' +
                '<span class="input-group-addon default-target-save"><i class="glyphicon glyphicon-ok-circle"></i></span></div></div>'
        }

        $('<div class="kpi-settings" role="tab">' +
            '<div class="kpi-name" unit="' + kpi.unit_string + '" id="' + kpi.id + '">' + kpi.name + '</div>' +
            '<div class="kpi-options pull-right">' +
            '<i class="glyphicon glyphicon-chevron-down collapsed" data-toggle="collapse" data-parent="#kpi_settings" href="#' + kpi.name + '" aria-expanded="false" aria-controls="' + kpi.name + '"></i>' +
            '<i class="glyphicon glyphicon-plus-sign add-kpi-target"></i>' +
            '</div><div class="kpi-body panel-body panel-collapse collapse in" id="' + kpi.name + '" role="tabpanel">' +
            '<div class="default-target row">' + SettingItemsHtml + '</div>' +
            '</div></div>').appendTo('#kpi_settings');
    } else {
        $('<div class="kpi-settings" role="tab">' +
            '<div class="kpi-name" unit="' + kpi.unit_string + '" id="' + kpi.id + '">' + kpi.name + '</div>' +
            '<div class="kpi-options pull-right">' +
            '<i class="glyphicon glyphicon-chevron-down collapsed" data-toggle="collapse" data-parent="#kpi_settings" href="#' + kpi.name + '" aria-expanded="false" aria-controls="' + kpi.name + '"></i>' +
            '<i class="glyphicon glyphicon-plus-sign add-kpi-target"></i>' +
            '</div><div class="kpi-body panel-body panel-collapse collapse"id="' + kpi.name + '" role="tabpanel"></div></div>').appendTo('#kpi_settings');
    }

    /*Target*/
    if (kpi.hasOwnProperty("targets") && kpi.targets.length > 0) {
        for (var tg = 0; tg < kpi.targets.length; tg++) {
            var KpiSetting = $('#' + kpi.id).parent();
            var UnitString = KpiSetting.find('.kpi-name').attr('unit');
            if (kpi.targets[tg].is_system) {
                $('<div class="col-lg-2 col-md-3 col-sm-4 col-xs-6">' +
                    '<div class="kpi-target" id="' + kpi.targets[tg].id + '">' +
                    '<div class="pull-right"></div>' +
                    '<div class="kpi-target-value">' + kpi.targets[tg].value + UnitString + '</div>' +
                    '<div class="kpi-target-name">' + kpi.targets[tg].name + '</div></div></div>').appendTo(KpiSetting.find('.kpi-body'));
            } else {
                $('<div class="col-lg-2 col-md-3 col-sm-4 col-xs-6">' +
                    '<div class="kpi-target" id="' + kpi.targets[tg].id + '">' +
                    '<div class="pull-right"><i class="kpi-target-remove glyphicon glyphicon-remove"></i></div>' +
                    '<div class="kpi-target-value">' + kpi.targets[tg].value + UnitString + '</div>' +
                    '<div class="kpi-target-name">' + kpi.targets[tg].name + '</div></div></div>').appendTo(KpiSetting.find('.kpi-body'));
            }
        }
    }
};

Settings.add_kpi_target = function (obj, div, targetName, targetValue) {
    $(obj).click(function () {
        var Panel = $(this).parent().parent();
        var PanelBody = Panel.find('.kpi-body');
        var PanelHeader = Panel.find('.kpi-name');

        $(this).popModal({
            html: $(div).html(),
            placement: 'bottomRight',
            showCloseBut: true,
            onDocumentClickClose: true,
            onOkBut: function () {
                var KPITargetName = $(targetName).val();
                var KPITargetValue = $(targetValue).val();
                var KPITargetUnit = PanelHeader.attr('unit');
                var KPITargetID = PanelHeader.attr('id');

                $.ajax({
                    url: '/kpis/settings/' + KPITargetID + '/targets',
                    type: 'post',
                    dataType: 'json',
                    data: {
                        target: {
                            name: KPITargetName,
                            value: KPITargetValue
                        }
                    },
                    success: function (data) {
                        if (data.result) {
                            $('<div class="col-lg-2 col-md-3 col-sm-4 col-xs-6">' +
                                '<div class="kpi-target" id="' + data.object.id + '">' +
                                '<div class="pull-right">' +
                                '<i class="kpi-target-remove glyphicon glyphicon-remove"></i></div>' +
                                '<div class="kpi-target-value">' + data.object.value + KPITargetUnit + '</div>' +
                                '<div class="kpi-target-name">' + data.object.name + '</div></div></div>').appendTo(PanelBody);
                        } else {
                            $('<div>' + data.content + '</div>').notifyModal();
                        }

                    },
                    error: function () {
                        console.log("Something Error!");
                    }
                });
            },
            onClose: function () {
            }
        });
    });
};

Settings.default_target_save = function () {
    $(document).on('click', '.default-target-save', function () {

        var setting_id = $(this).parent().parent().parent().parent().parent().find('.kpi-name').attr('id');
        var setting_item_id = $(this).parent().find('.input-group-addon').attr("id");
        var setting_name = $(this).parent().find('.input-group-addon').attr("name");
        var setting_value = $(this).parent().find('.form-control').val();

        if (!isNaN(setting_value) && setting_value > 0) {
            $.ajax({
                url: '/kpis/settings/' + setting_id + "/setting_items/" + setting_item_id,
                type: 'put',
                dateType: 'json',
                data: {
                    setting_item: {
                        field_value: setting_value
                    }
                },
                success: function (data) {
                    console.log(data);
                    if (data.result) {
                        $('<div>修改成功</div>').notifyModal();
                    } else {
                        $('<div>修改失败</div>').notifyModal();
                    }
                },
                error: function () {
                    console.log("Something Error!");
                }
            })
        } else {
            $('<div>value 只能是大于０的数字</div>').notifyModal();
        }
    });
};

Settings.remove_target = function () {
    $('.kpi-target-remove').unbind('click').click(function () {
        var KPITarget = $(this).parent().parent();
        var TargetID = KPITarget.attr("id");
        var KPITargetID = KPITarget.parent().parent().parent().find('.kpi-name').attr('id');

        if (confirm("are you sure?")) {
            $.ajax({
                url: '/kpis/settings/' + KPITargetID + '/targets/' + TargetID,
                type: 'delete',
                dataType: 'json',
                success: function (data) {
                    if (data.result) {
                        $('<div>删除成功</div>').notifyModal();
                        KPITarget.parent().remove();
                    } else {
                        $('<div>删除失败</div>').notifyModal();
                    }
                },
                error: function () {
                    console.log("Something Error!");
                }
            });
        }
    });
};

Settings.CheckEmail = function (div, val) {
    $.ajax({
        url: '/users/check_email',
        type: 'get',
        data: {
            email: val
        },
        success: function (data) {
            console.log(data);
            if (data.result) {

            } else {
                $(div).tagEditor('removeTag', val);
                $('<div>' + val + ' is not exist.</div>').notifyModal();
            }
        },
        error: function () {
            console.log("ADD PDCA User Wrong!");
            $(div).tagEditor('removeTag', val);
            $('<div>Something Error!</div>').notifyModal();
        }
    })
};

Settings.ClosePop = function (div) {
    $('.md-close').click(function () {
        $(div).removeClass('md-show');
    });
};