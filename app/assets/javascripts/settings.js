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

    $(document).on('click', '.kpi-target', function () {
        Settings.pop_kpi_target(this, '#round-target-modal', '.input-round-target-name', '.input-round-target-value');
    });

    $(document).on('click', '.glyphicon-chevron-down', function () {
        $('.glyphicon-chevron-down').each(function () {
            $(this).css({'transform': 'rotate(0deg)'});
            $("#" + $(this).attr('aria-controls')).collapse('hide');
        });

        $(this).css({'transform': 'rotate(180deg)'});
        $("#" + $(this).attr('aria-controls')).collapse('show');
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
        $('<div class="kpi-settings" role="tab" id="target' + kpi.id + '">' +
            '<div class="kpi-name" unit="' + kpi.unit_string + '" id="' + kpi.id + '">' + kpi.name + '</div>' +
            '<div class="kpi-options pull-right">' +
            '<i class="glyphicon glyphicon-chevron-down" data-toggle="collapse" data-parent="#kpi_settings" href="#' + kpi.name + '" aria-expanded="false" aria-controls="' + kpi.name + '"></i>' +
            '<i class="glyphicon glyphicon-plus-sign add-kpi-target"></i>' +
            '</div><div class="kpi-body panel-body panel-collapse collapse" id="' + kpi.name + '" role="tabpanel" aria-labelledby="target' + kpi.id + '">' +
            '<div class="default-target row">' + SettingItemsHtml + '</div>' +
            '</div></div>').appendTo('#kpi_settings');
    } else {
        $('<div class="kpi-settings" role="tab">' +
            '<div class="kpi-name" unit="' + kpi.unit_string + '" id="' + kpi.id + '">' + kpi.name + '</div>' +
            '<div class="kpi-options pull-right">' +
            '<i class="glyphicon glyphicon-chevron-down" data-toggle="collapse" data-parent="#kpi_settings" href="#' + kpi.name + '" aria-expanded="false" aria-controls="' + kpi.name + '"></i>' +
            '<i class="glyphicon glyphicon-plus-sign add-kpi-target"></i>' +
            '</div><div class="kpi-body panel-body panel-collapse collapse"id="' + kpi.name + '" role="tabpanel" aria-labelledby="target' + kpi.id + '"></div></div>').appendTo('#kpi_settings');
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
                    '<div class="kpi-target-value"><span>' + kpi.targets[tg].value + '</span><span>' + UnitString + '</span></div>' +
                    '<div class="kpi-target-name">' + kpi.targets[tg].name + '</div></div></div>').appendTo(KpiSetting.find('.kpi-body'));
            } else {
                $('<div class="col-lg-2 col-md-3 col-sm-4 col-xs-6">' +
                    '<div class="kpi-target" id="' + kpi.targets[tg].id + '">' +
                    '<div class="pull-right"><i class="kpi-target-remove glyphicon glyphicon-remove"></i></div>' +
                    '<div class="kpi-target-value"><span>' + kpi.targets[tg].value + '</span><span>' + UnitString + '</span></div>' +
                    '<div class="kpi-target-name">' + kpi.targets[tg].name + '</div></div></div>').appendTo(KpiSetting.find('.kpi-body'));
            }
        }
    }
};

Settings.pop_kpi_target = function (obj, div, targetName, targetValue) {
    var update = $(obj).hasClass('kpi-target');
    
    $(obj).popModal({
        html: $(div).html(),
        placement: 'rightCenter',
        showCloseBut: true,
        onDocumentClickClose: true,
        onLoad: function () {
            if (update) {
                $(targetName).val($(obj).find('.kpi-target-name').text());
                $(targetValue).val($(obj).find('.kpi-target-value').children('span').first().text());
            }
        },
        onOkBut: function () {
            var KPITargetName = $(targetName).val();
            var KPITargetValue = $(targetValue).val();

            var SettingId = $(obj).parent().parent().parent().find('.kpi-name').attr('id');

            if (update) {
                var targetId = $(obj).attr('id');
                $.ajax({
                    url: '/kpis/settings/' + SettingId + '/targets/' + targetId,
                    type: 'put',
                    dataType: 'json',
                    data: {
                        id: targetId,
                        target: {
                            name: KPITargetName,
                            value: KPITargetValue
                        }
                    },
                    success: function (data) {
                        if (data.result) {
                            $(obj).find('.kpi-target-name').text(data.object.name);
                            $(obj).find('.kpi-target-value').children('span').first().text(data.object.value);

                            $('<div>更新成功</div>').notifyModal();
                        } else {
                            $('<div>' + data.content + '</div>').notifyModal();
                        }

                    },
                    error: function () {
                        console.log("Something Error!");
                    }
                });
            } else {
                var Panel = $(obj).parent().parent();
                var PanelBody = Panel.find('.kpi-body');
                var PanelHeader = Panel.find('.kpi-name');
                var KPITargetUnit = PanelHeader.attr('unit');
                var SettingId = PanelHeader.attr('id');

                $.ajax({
                    url: '/kpis/settings/' + SettingId + '/targets',
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
                                '<div class="kpi-target-value"><span>' + data.object.value + '</span><span>' + KPITargetUnit + '</span></div>' +
                                '<div class="kpi-target-name">' + data.object.name + '</div></div></div>').appendTo(PanelBody);
                        } else {
                            $('<div>' + data.content + '</div>').notifyModal();
                        }

                    },
                    error: function () {
                        console.log("Something Error!");
                    }
                });
            }
        },
        onClose: function () {
            $(targetName).val('');
            $(targetValue).val('');
        }
    });
};

Settings.add_kpi_target = function (obj, div, targetName, targetValue) {
    $(obj).click(function () {
        Settings.pop_kpi_target(this, div, targetName, targetValue);
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

Settings.round_layout = function (DiagramID) {
    var colors = {
        pointBg: "green",
        whiteFontColor: "#fff",
        workerFont: "#404040",
        workStationUnSelectBg: "lightseagreen",
        workStationSelectBg: "dodgerblue",
        pointBlink: "orange"
    };

    var $_$ = go.GraphObject.make;

    myDiagram = $_$(go.Diagram, "myDiagramDiv",
        {
            initialAutoScale: go.Diagram.Uniform,
            "animationManager.isEnabled": false,
            // initialContentAlignment: go.Spot.Center,
            allowDrop: true,
            mouseDrop: function (e) {
                finishDrop(e, null)
            },
            // "commandHandler.archetypeGroupData": {isGroup: true, text: "分组"},
            "undoManager.isEnabled": false
        }
    );

    myDiagram.addDiagramListener("ChangedSelection", function(e){
        var SelectedNode = myDiagram.selection.first();
        if(SelectedNode!= null || SelectedNode!= ""){
            Settings.ShowNodeData(SelectedNode, DiagramID);
        }
    })

    myDiagram.addDiagramListener("Modified", function (e) {
        var button = document.getElementById("saveModel");
        if (button) button.disabled = !myDiagram.isModified;
        var idx = document.title.indexOf("*");
        if (myDiagram.isModified) {
            if (idx < 0) document.title += "*";
        } else {
            if (idx >= 0) document.title = document.title.substr(0, idx);
        }
    });

    myDiagram.groupTemplateMap.add("WorkGroup",
        $_$(go.Group, "Auto",
            {
                resizable: true,
                resizeObjectName: "Panel",
                ungroupable: true,
                mouseDragEnter: function (e, grp, prev) {
                    highlightGroup(e, grp, true);
                },
                mouseDragLeave: function (e, grp, next) {
                    highlightGroup(e, grp, false);
                },
                computesBoundsAfterDrag: true,
                mouseDrop: finishDrop,
                handlesDragDropForMembers: true // don't need to define handlers on member Nodes and Links
            },
            new go.Binding("location", "location", go.Point.parse).makeTwoWay(go.Point.stringify),
            new go.Binding("background", "isHighlighted", function (h) {
                return h ? "rgba(255,0,0,0.2)" : "transparent";
            }).ofObject(),
            $_$(go.Shape, "Rectangle",
                {fill: null, stroke: "#33D3E5", strokeWidth: 2}),
            $_$(go.Panel, "Vertical",
                {
                    name: "Panel"
                },
                new go.Binding("desiredSize", "size", go.Size.parse).makeTwoWay(go.Size.stringify),
                $_$(go.Panel, "Horizontal",
                    {
                        stretch: go.GraphObject.Horizontal,
                        background: "#33D3E5"
                    },
                    $_$(go.TextBlock,
                        {
                            isMultiline: false,
                            alignment: go.Spot.Left,
                            editable: true,
                            margin: 5,
                            font: "bold 14px sans-serif",
                            stroke: "#404040"
                        },
                        new go.Binding("text", "text").makeTwoWay())
                ),
                $_$(go.Placeholder,
                    {
                        padding: 5,
                        alignment: go.Spot.TopLeft
                    })
            )
        )
    );

    // Worker
    myDiagram.nodeTemplateMap.add("Worker",
        $_$(go.Node, go.Panel.Auto, {
                margin: new go.Margin(0, 0, 10, 0),
                cursor: "pointer"
            },
            new go.Binding("location", "location", go.Point.parse).makeTwoWay(go.Point.stringify),
            $_$(go.Panel, "Horizontal",
                $_$(go.Picture,
                    {
                        width: 20,
                        height: 20,
                        margin: new go.Margin(0, 4, 0, 0),
                        imageStretch: go.GraphObject.Uniform,
                        source: '/assets/ie-structure/user.png'
                    }
                ),
                $_$(go.TextBlock, "员工",
                    {
                        isMultiline: false,
                        font: "bold 12pt Helvetica, Arial, sans-serif",
                        stroke: colors["workerFont"],
                        editable: true,
                        textAlign: "center"
                    },
                    new go.Binding("text", "text").makeTwoWay())
            )
        )
    );

    //WorkStation
    myDiagram.groupTemplateMap.add("WorkStation",
        $_$(go.Group, go.Panel.Auto,
            {
                resizable: true,
                resizeObjectName: "Panel",
                ungroupable: false,
                background: colors["workStationUnSelectBg"],
                cursor: "pointer",
                computesBoundsAfterDrag: true,
                mouseDrop: canDrop,
                handlesDragDropForMembers: true
            },  
            new go.Binding("background", "background").makeTwoWay(),
            new go.Binding("location", "location", go.Point.parse).makeTwoWay(go.Point.stringify),
            $_$(go.Shape, "Rectangle",
                {
                    stroke: "transparent",
                    visible: false
                }),
            $_$(go.Shape, "Circle",
                {
                    name: "POINT",
                    alignment: go.Spot.TopRight,
                    stroke: null,
                    fill: colors["pointBg"],
                    margin: new go.Margin(5, 5, 0, 0),
                    desiredSize: new go.Size(20, 20)
                }),
            $_$(go.TextBlock, "P", {
                alignment: go.Spot.TopRight,
                editable: false,
                margin: new go.Margin(10, 10, 0, 0),
                font: "bold 13px sans-serif",
                stroke: colors["whiteFontColor"]
            }), new go.Binding("text", "text"),
            $_$(go.Shape, borderStyle(),
                {
                    alignment: go.Spot.Bottom,
                    name: "CHECK",
                    fill: 'transparent',
                    stroke: "transparent",
                    width: 14,
                    height: 14,
                    visible: false
                },
                new go.Binding("visible", "isSelected").makeTwoWay()),
            {
                click: function (e, obj) {
                    var oldskips = obj.diagram.skipsUndoManager;
                    obj.diagram.skipsUndoManager = true;
                    if (obj.background === colors["workStationUnSelectBg"]) {
                        obj.background = colors["workStationSelectBg"];
                        console.log("选中");
                    } else {
                        console.log("未选中");
                        obj.background = colors["workStationUnSelectBg"];
                    }

                    obj.diagram.skipsUndoManager = oldskips;

                    var shape = obj.findObject("CHECK");
                    shape.diagram.startTransaction("checkbox");
                    shape.visible = !shape.visible;
                    shape.diagram.commitTransaction("checkbox");
                }
            },
            $_$(go.Panel, go.Panel.Vertical,
                {
                    name: "Panel"
                },
                new go.Binding("desiredSize", "size", go.Size.parse).makeTwoWay(go.Size.stringify),
                $_$(go.Panel, go.Panel.Auto,
                    $_$(go.TextBlock,
                        {
                            isMultiline: false,
                            alignment: go.Spot.Left,
                            editable: true,
                            margin: new go.Margin(5, 0, 0, 0),
                            font: "bold 16px sans-serif",
                            stroke: colors["whiteFontColor"]
                        },
                        new go.Binding("text", "text").makeTwoWay()
                    )
                )
            )
        )
    );

    myDiagram.addModelChangedListener(function (e) {
        if (e.model.skipsUndoManager) return;

        if (e.modelChange === "nodeGroupKey" || e.modelChange === "nodeParentKey") {
            console.log('model Change   Node GroupKey')
        } else if (e.change === go.ChangedEvent.Property) {
            var treenode = myDiagram.findNodeForData(e.object);
            if (treenode !== null) {
                if (e.mm == "text") {
                    console.log("修改节点文本");
                    var UpdateNode = e.object;

                    $.ajax({
                        url: '/diagrams/' + DiagramID + '/nodes/' + UpdateNode.key,
                        type: 'put',
                        dataType: 'json',
                        data: {
                            id: UpdateNode.key,
                            node: {
                                name: UpdateNode.text,
                                code: UpdateNode.code
                            }
                        },
                        success: function (data) {
                            if (data.result) {
                                console.log(data);
                                console.log(UpdateNode);
                                treenode.updateTargetBindings();
                            } else {
                                $('<div>' + data.content + '</div>').notifyModal();
                                e.object.text = data.object.name;
                            }
                        },
                        error: function () {
                            console.log("Something Error!");
                        }
                    });
                }
            }
        } else if (e.change === go.ChangedEvent.Insert && e.propertyName === "nodeDataArray") {
            var NewNode = e.newValue;
            var Type = 100;
            if (NewNode.category == "WorkStation") {
                Type = 200;
            } else if (NewNode.category == "WorkGroup") {
                Type = 300;
            }

            $.ajax({
                url: '/diagrams/' + DiagramID + '/nodes',
                type: 'post',
                dataType: 'json',
                async: false,
                data: {
                    node: {
                        name: NewNode.text,
                        type: Type
                    }
                },
                success: function (data) {
                    console.log(data);
                    if (data.result) {
                        NewNode.key = data.object.id;
                        NewNode.text = data.object.name;
                        NewNode.device_code = "";
                        NewNode.code = data.object.code;
                        NewNode.node_set_id = data.object.node_set_id;
                    } else {
                        $('<div>' + data.content + '</div>').notifyModal();
                    }
                },
                error: function () {
                    console.log("Something Error!");
                }
            });
        } else if (e.change.name === "Remove" && e.propertyName === "nodeDataArray") {
            var treenode = e.oldValue;

            if (treenode !== null) {
                $.ajax({
                    url: '/diagrams/' + DiagramID + '/nodes/' + treenode.key,
                    type: 'delete',
                    dataType: 'json',
                    success: function (data) {
                        if (data.result) {
                            console.log(data);
                        } else {
                            $('<div>' + data.content + '</div>').notifyModal();
                        }
                    },
                    error: function () {
                        console.log("Something Error!");
                    }
                });
            }
        }

        if (e.propertyName === "CommittedTransaction") {
            var Operate = e.oldValue;
            // if (Operate === "Initial Layout") {
            //     console.log("Layout" + Operate);
            // } else if (Operate === "Move") {
            //     console.log("move" + Operate);
            // } else if (Operate === "Resizing") {
            //     console.log("Resizing" + Operate);
            //     save();
            // } else
            if (Operate === "Copy" || Operate === "ExternalCopy") {
                //复制，添加新节点
                console.log("Cocy" + Operate);
                load();
            }
            // else if (Operate === "TextEditing") {
            //     //编辑文本
            //     console.log("Text Edit" + Operate);
            //     console.log(UpdateNode);
            // } else if (Operate === "Delete") {
            //     //删除
            //     console.log("Delete" + Operate);
            // } else if (Operate === "checkbox") {
            //     //选中不选中
            //     console.log("Checkbox===" + Operate);
            // }
        }
    });

    myPalette =
        $_$(go.Palette, "myPaletteDiv",  // must name or refer to the DIV HTML element
            {
                initialContentAlignment: go.Spot.Center,
                initialAutoScale: go.Diagram.UniformToFill,
                "animationManager.duration": 200, // slightly longer than default (600ms) animation
                nodeTemplateMap: myDiagram.nodeTemplateMap,  // share the templates used by myDiagram
                groupTemplateMap: myDiagram.groupTemplateMap,
                layout: $_$(go.GridLayout,
                    {
                        wrappingColumn: 3,
                        alignment: go.GridLayout.Position,
                        cellSize: new go.Size(1, 1),
                        spacing: new go.Size(4, 4)
                    }),
                model: new go.GraphLinksModel([  // specify the contents of the Palette
                    {
                        category: "WorkStation",
                        size: "80 40",
                        text: "工位",
                        background: colors["workStationUnSelectBg"],
                        isGroup: true,
                        code: "",
                        node_set_id: ""
                    }, {
                        category: "Worker",
                        text: "员工",
                        code: "",
                        node_set_id: ""
                    }, {
                        category: "WorkGroup",
                        text: "分组",
                        isGroup: true,
                        size: "80 40",
                        code: "",
                        node_set_id: ""
                    }
                ], [])
            }
        );

    // this function is used to highlight a Group that the selection may be dropped into
    function highlightGroup(e, grp, show) {
        if (!grp) return;
        e.handled = true;
        if (show) {
            var tool = grp.diagram.toolManager.draggingTool;
            var map = tool.draggedParts || tool.copiedParts;  // this is a Map
            if (grp.canAddMembers(map.toKeySet())) {
                grp.isHighlighted = true;
                return;
            }
        }
        grp.isHighlighted = false;
    }

    function finishDrop(e, grp) {
        var ok = (grp !== null
            ? grp.addMembers(grp.diagram.selection, true)
            : e.diagram.commandHandler.addTopLevelParts(e.diagram.selection, true));
        if (!ok) e.diagram.currentTool.doCancel();
    }

    function canDrop(e, grp) {
        if (e.diagram.selection.Ch.key.data.category == "WorkStation") {
            $('<div>工位不能嵌套</div>').notifyModal();
            e.diagram.currentTool.doCancel();
        } else {
            var ok = (grp !== null
                ? grp.addMembers(grp.diagram.selection, true)
                : e.diagram.commandHandler.addTopLevelParts(e.diagram.selection, true));
            if (!ok) e.diagram.currentTool.doCancel();
        }
    }

    function borderStyle() {
        return {
            fill: colors["whiteFontColor"],
            stroke: colors["workStationUnSelectBg"],
            strokeWidth: 2
        };
    }
};

Settings.ShowNodeData = function(node, DiagramID){
    if(node != "" && node != null){
        $('#CollapseNodeData').attr('class', 'glyphicon glyphicon-menu-right');
        $('#myDiagramDiv').parent().css({width: '80%'});
        $('#NodeDataView').parent().css({display: 'inline-block'});
        $('#NodeDataView').empty();
        
        var NodeDataHtml = NodeData('key', node.data.key, 'text', true) +  
            NodeData('type', node.data.category, 'text', true) +
            // NodeData('code', node.data.code, 'text', true) +
            // NodeData('size', node.data.size, 'text', false) +
            NodeData('name', node.data.text, 'text', false) + 
            NodeData('device', node.data.device_code, 'text', false) + 
            NodeData('location', node.data.location, 'text', false);

        if(node.data.category != "Worker"){
           NodeDataHtml +=NodeData('size', node.data.size, 'text', false);
        }
        
        $(NodeDataHtml).appendTo('#NodeDataView');

        $('#NodeDataView').unbind('change').on('change', '.form-control', function(){
           var Property = $(this).attr('aria-describedby');
           var Value = $(this).val();
           if(Property=="name"){
            $.ajax({
                url: '/diagrams/' + DiagramID + '/nodes/' + node.data.key,
                type: 'put',
                dataType: 'json',
                data: {
                    id: node.data.key,
                    node: {
                        name: Value,
                        code: node.data.code
                    }
                },
                success: function (data) {
                    if (data.result) {
                        node.data.text = Value;
                        node.updateTargetBindings();
                        console.log(data);
                    } else {
                        $('<div>' + data.content + '</div>').notifyModal();
                        e.object.text = data.object.name;
                    }
                },
                error: function () {
                    console.log("Something Error!");
                }
            });
           }else if(Property === "size"){
            node.data.size = Value;
            node.updateTargetBindings();
           }else if (Property === "location"){
            // 修改Location
            node.data.location = Value;
            node.updateTargetBindings();
           }else if (Property === "device"){
            node.data.device_code = Value;
            node.updateTargetBindings();
           }

           save();
        });
    }else{
        $('#CollapseNodeData').attr('class', 'glyphicon glyphicon-menu-left');
        $('#myDiagramDiv').parent().css({width: '100%'});
        $('#NodeDataView').parent().css({display: 'none'});
    }
}

function NodeData (name, value, input_type, disabled){
    if(disabled){
        return '<div class="input-group" style="margin-top: 5px;"> <span style="min-width:80px; border-radius: 0; border-color: rgb(35, 183, 229);" class="input-group-addon" id="'+name+'"> '+name +'</span> '+
    '<input style="border-radius: 0; border-color: rgb(35, 183, 229);" type="'+input_type+'" disabled class="form-control" placeholder="'+name+'" aria-describedby="'+name+'" value="'+value+'"></div>' 
    }else{
        return '<div class="input-group" style="margin-top: 5px;"> <span style="min-width:80px;border-radius: 0;border-color: rgb(35, 183, 229);" class="input-group-addon" id="'+name+'"> '+name +'</span> '+
    '<input style="border-radius: 0; border-color: rgb(35, 183, 229);" type="'+input_type+'" class="form-control" placeholder="'+name+'" aria-describedby="'+name+'" value="'+value+'"></div>'
    }
}

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

Settings.DrawCharts = function (div, title, subtitle, x_categories, unit, series, ChartStyle, ColumnColor) {
    $(div).highcharts({
        chart: {
            backgroundColor: ChartStyle.ChartBackground,
            spacingRight: 20
        },
        title: {
            text: title, x: -20,
            style: {
                color: ChartStyle.label_font_color
            }
        },
        subtitle: {
            text: subtitle,
            x: 40,
            align: 'center',
            style: {
                color: ChartStyle.label_font_color
            }
        },
        credits: {
            enabled: false
        },
        xAxis: {
            categories: x_categories,
            labels: {
                formatter: function () {
                    return this.value;
                },
                style: {
                    color: ChartStyle.label_font_color
                }
            }
        },
        yAxis: {
            title: {
                text: "",
                style: {
                    color: ChartStyle.label_font_color
                }
            },
            plotLines: [{
                value: 0,
                width: 1,
                color: ChartStyle.label_font_color
            }],
            label: {
                style: {
                    color: ChartStyle.label_font_color
                }
            }
        },
        tooltip: {
            valueSuffix: unit,
            formatter: function () {
                return '<span><b>' + this.x + '</b><br/><b>' + title + ':</b>' + this.y + unit + '</span>'
            },
            style: {
                color: ChartStyle.tooltips_font_color
            },
            useHTML: true
        },
        legend: {
            layout: 'horizontal',
            align: 'center',
            verticalAlign: 'bottom',
            itemStyle: {
                color: ChartStyle.label_font_color
            }
        },
        plotOptions: {
            column: {
                dataLabels: {
                    enabled: true,
                    format: '{y}' + unit,
                    color: ChartStyle.label_font_color
                },
                events: {
                    click: function (e) {
                        //Click
                    }
                },
                color: ChartStyle.label_font_color,
                borderWidth: "0"
            }
        },
        series: [{
            type: "column",
            name: title,
            data: series,
            color: ColumnColor
        }]
    });
};