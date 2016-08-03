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
    console.log('.,............');
    console.log(obj);
    console.log(div);
    console.log('.,............');

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
            "animationManager.isEnabled": false,  // turn off automatic animations
            // initialContentAlignment: go.Spot.Center,
            allowDrop: true,
            mouseDrop: function (e) {
                finishDrop(e, null)
            },
            // "commandHandler.archetypeGroupData": {isGroup: true, text: "分组"},
            "undoManager.isEnabled": true,
            "ChangedSelection": function (e) {
                if (myChangingSelection) return;
                myChangingSelection = true;
                var diagnodes = new go.Set();
                myDiagram.selection.each(function (n) {
                    diagnodes.add(myTreeView.findNodeForData(n.data));
                });
                myTreeView.clearSelection();
                myTreeView.selectCollection(diagnodes);
                myChangingSelection = false;
            }
        }
    );

    var myChangingSelection = false;  // to protect against recursive selection changes


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
            new go.Binding("background", "isHighlighted", function (h) {
                return h ? "rgba(255,0,0,0.2)" : "transparent";
            }).ofObject(),
            $_$(go.Shape, "Rectangle",
                {fill: null, stroke: "#33D3E5", strokeWidth: 2}),
            $_$(go.Panel, "Vertical",
                {
                    name: "Panel"
                },
                $_$(go.Panel, "Horizontal",
                    {
                        stretch: go.GraphObject.Horizontal,
                        background: "#33D3E5"
                    },
                    // $_$("SubGraphExpanderButton",
                    //     {
                    //         alignment: go.Spot.Right,
                    //         margin: 5
                    //     }),
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
                        alignment: go.Spot.Center
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

//    WorkStation
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
        // don't need to start/commit a transaction because the UndoManager is shared with myTreeView
        if (e.modelChange === "nodeGroupKey" || e.modelChange === "nodeParentKey") {
            // handle structural change: group memberships
            var treenode = myTreeView.findNodeForData(e.object);
            if (treenode !== null) treenode.updateRelationshipsFromData();

            console.log(e.object);

            console.log('model Change   Node GroupKey')

        } else if (e.change === go.ChangedEvent.Property) {
            var treenode = myTreeView.findNodeForData(e.object);
            if (treenode !== null) treenode.updateTargetBindings();
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
                        console.log("ChangeEvent . Property")
                    },
                    error: function () {
                        $('<div>Something Error!</div>').notifyModal();
                    }
                });
            }
        } else if (e.change === go.ChangedEvent.Insert && e.propertyName === "nodeDataArray") {
            var NewNode = e.newValue;
            var NewParam = e.newParam;
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

                    NewNode.key = data.id;
                    NewNode.text = data.name;
                    NewNode.code = data.code;
                    NewNode.node_set_id = data.node_set_id;

                    myTreeView.model.nodeDataArray.splice(NewParam, 1);
                    myTreeView.model.addNodeData(NewNode);

                    /*此处　使用外部调用*/

                },
                error: function () {
                    console.log("Something Error!");
                }
            });
        } else if (e.change === go.ChangedEvent.Remove && e.propertyName === "nodeDataArray") {
            console.log(' Change   Remove NodeDataArray');
            // remove the corresponding node from myTreeView
            var treenode = myTreeView.findNodeForData(e.oldValue);
            if (treenode !== null) {
                myTreeView.remove(treenode);
                $.ajax({
                    url: '/diagrams/' + DiagramID + '/nodes/' + treenode.data.key,
                    type: 'delete',
                    dataType: 'json',
                    success: function (data) {
                        console.log(data);
                    },
                    error: function () {
                        console.log("Something Error!");
                    }
                });
            }

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
                // allowHorizontalScroll: false,
                // allowVerticalScroll: false,
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
                        isGroup: true
                    }
                ], [])
            }
        );

    myTreeView = $_$(go.Diagram, "myTreeView",
        {
            "animationManager.isEnabled": false,  // turn off automatic animations
            allowMove: false,  // don't let users mess up the tree
            allowCopy: false,  // but you might want this to be false
            "commandHandler.copiesTree": false,
            "commandHandler.copiesParentKey": false,
            allowDelete: true,  // but you might want this to be false
            "commandHandler.deletesTree": true,
            allowHorizontalScroll: false,
            allowVerticalScroll: true,
            layout: $_$(go.TreeLayout,
                {
                    alignment: go.TreeLayout.AlignmentStart,
                    angle: 0,
                    compaction: go.TreeLayout.CompactionNone,
                    layerSpacing: 16,
                    layerSpacingParentOverlap: 1,
                    nodeIndent: 2,
                    nodeIndentPastParent: 0.88,
                    nodeSpacing: 5,
                    setsPortSpot: false,
                    setsChildPortSpot: false
                }),
            // when a node is selected in the tree, select the corresponding node in the main diagram
            "ChangedSelection": function (e) {
                if (myChangingSelection) return;
                myChangingSelection = true;
                var diagnodes = new go.Set();
                myTreeView.selection.each(function (n) {
                    diagnodes.add(myDiagram.findNodeForData(n.data));
                });
                myDiagram.clearSelection();
                myDiagram.selectCollection(diagnodes);
                myChangingSelection = false;
            }
        }
    );

    myTreeView.nodeTemplateMap.add("Worker",
        $_$(go.Node,
            {
                selectionAdorned: true
            },
            $_$(go.Panel, "Horizontal",
                $_$(go.Picture,
                    {
                        width: 24,
                        height: 24,
                        margin: new go.Margin(0, 4, 0, 0),
                        imageStretch: go.GraphObject.Uniform
                    },
                    new go.Binding("source", "isTreeLeaf", imageConverter).ofObject()),
                $_$(go.TextBlock,
                    {
                        isMultiline: false,
                        font: '9pt Verdana, sans-serif',
                        editable: true,
                        textAlign: "center"
                    },
                    new go.Binding("text", "text").makeTwoWay()
                )
            )
        )
    );

    //WorkStation
    myTreeView.nodeTemplateMap.add("WorkStation",
        $_$(go.Node,
            {
                selectionAdorned: true
            },
            $_$("TreeExpanderButton",
                {
                    width: 20,
                    "ButtonBorder.fill": "#f3f3f3",
                    "ButtonBorder.stroke": null,
                    "_buttonFillOver": "rgba(0,128,255,0.25)",
                    "_buttonStrokeOver": null
                }),
            $_$(go.Panel, "Horizontal",
                {
                    position: new go.Point(16, 0)
                },
                $_$(go.Panel, "Horizontal",
                    $_$(go.Shape, borderStyle(),
                        {width: 14, height: 14}),
                    $_$(go.Shape, borderStyle(),
                        {
                            name: "CHECK",
                            fill: colors["workStationSelectBg"],
                            width: 14,
                            height: 14,
                            margin: new go.Margin(0, 0, 0, -16),
                            visible: false
                        },
                        new go.Binding("visible", "isSelected").makeTwoWay()),
                    {
                        click: function (e, obj) {
                            var shape = obj.findObject("CHECK");
                            shape.diagram.startTransaction("checkbox");
                            shape.visible = !shape.visible;
                            shape.diagram.commitTransaction("checkbox");
                        }
                    },
                    $_$(go.Picture,
                        {
                            width: 24,
                            height: 24,
                            margin: new go.Margin(0, 4, 0, 0),
                            imageStretch: go.GraphObject.Uniform,
                            source: '/assets/ie-structure/tree.png'
                        }
                    ),
                    $_$(go.TextBlock,
                        {
                            isMultiline: false,
                            font: '9pt Verdana, sans-serif',
                            editable: true,
                            textAlign: "center"
                        },
                        new go.Binding("text", "text").makeTwoWay()
                    )
                )
            )
        )
    );

    // with lines
    myTreeView.linkTemplate = $_$(go.Link,
        {
            selectable: false,
            routing: go.Link.Orthogonal,
            fromEndSegmentLength: 4,
            toEndSegmentLength: 4,
            fromSpot: new go.Spot(0.001, 1, 7, 0),
            toSpot: go.Spot.Left
        },
        $_$(go.Shape,
            {stroke: 'black'})
    );

    myTreeView.model = $_$(go.TreeModel, {nodeParentKeyProperty: "group"});

    myTreeView.addModelChangedListener(function (e) {
        if (e.model.skipsUndoManager) return;
        // don't need to start/commit a transaction because the UndoManager is shared with myDiagram
        if (e.modelChange === "nodeGroupKey" || e.modelChange === "nodeParentKey") {
            // handle structural change: tree parent/children
            var node = myDiagram.findNodeForData(e.object);
            if (node !== null) node.updateRelationshipsFromData();

            console.log("nodeGroupKey Tree ,,,,,,,")

        } else if (e.change === go.ChangedEvent.Property) {
            console.log("ChangeTree Property");
            var node = myDiagram.findNodeForData(e.object);
            // var Point = node.findObject("POINT");
            if (node !== null) {
                if (node.data.isSelected) {
                    node.data.background = colors["workStationSelectBg"];
                    /*选中*/
                    console.log("选中");
                    // BlinkTreeInterval = setInterval(function () {
                    //     if (Point.fill == colors["pointBg"])
                    //         Point.fill = colors["pointBlink"];
                    //     else
                    //         Point.fill = colors["pointBg"];
                    // }, 500);

                } else {
                    /*未选中*/
                    console.log("未选中");
                    // clearInterval(BlinkTreeInterval);
                    node.data.background = colors["workStationUnSelectBg"];
                }

                node.updateTargetBindings();

                console.log("ChangeEvent  Property  Tree .....");
            }
        } else if (e.change === go.ChangedEvent.Insert && e.propertyName === "nodeDataArray") {
            // myDiagram.model.nodeDataArray.splice(e.newParam, 1);
            // myDiagram.model.addNodeData(e.newValue);

            console.log("Add New Value Tree ,,,,,,,");
        } else if (e.change === go.ChangedEvent.Remove && e.propertyName === "nodeDataArray") {
            // remove the corresponding node from the main Diagram
            var node = myDiagram.findNodeForData(e.oldValue);
            if (node !== null) myDiagram.remove(node);

            $.ajax({
                url: '/diagrams/' + DiagramID + '/nodes/' + node.data.key,
                type: 'delete',
                dataType: 'json',
                success: function (data) {
                    console.log(data);
                },
                error: function () {
                    console.log("Something Error!");
                }
            });
        }
    });

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

    function pointBlink(Point, obj) {
        if (obj.background === colors["workStationUnSelectBg"]) {
            obj.background = colors["workStationSelectBg"];
            /*选中*/
            console.log("选中");
            BlinkDiagramInterval = setInterval(function () {
                console.log("选中１１１１");
                if (Point.fill == colors["pointBg"])
                    Point.fill = colors["pointBlink"];
                else
                    Point.fill = colors["pointBg"];
            }, 500);
        } else {
            /*未选中*/
            console.log("未选中");
            console.log(BlinkDiagramInterval);

            window.clearInterval(BlinkDiagramInterval);

            Point.fill == colors["pointBg"];

            obj.background = colors["workStationUnSelectBg"];
        }
    }

    function borderStyle() {
        return {
            fill: colors["whiteFontColor"],
            stroke: colors["workStationUnSelectBg"],
            strokeWidth: 2
        };
    }

    function imageConverter(prop, picture) {
        var node = picture.part;
        if (node.isTreeLeaf) {
            return "/assets/ie-structure/user.png";
        } else {
            if (node.isTreeExpanded) {
                return "/assets/ie-structure/openFolder.png";
            } else {
                return "/assets/ie-structure/closedFolder.png";
            }
        }
    }
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