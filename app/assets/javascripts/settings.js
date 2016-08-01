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
        blue: "#00B5CB",
        orange: "#F47321",
        green: "#C8DA2B",
        gray: "#888",
        white: "#fff",
        black: "#000",
        defaultFill: "lightseagreen",
        workpositonPoint: 'lightblue',
        workpositionStorke: 'lightblue',
        UnselectedBrush: 'lightseagreen',
        SelectedBrush: 'dodgerblue'
    };

    function isUnoccupied(r, node) {
        var diagram = node.diagram;

        function navig(obj) {
            var part = obj.part;
            if (part === node) return null;
            if (part instanceof go.Link) return null;

            if (part.category == "WorkStation") {
                return part;
            } else {
                return null;
            }
        }

        var lit = diagram.layers;
        while (lit.next()) {
            var lay = lit.value;
            if (lay.isTemporary) continue;
            if (lay.findObjectsIn(r, navig, null, true).count > 0) return false;
        }
        return true;
    }

    // a Part.dragComputation function that prevents a Part from being dragged to overlap another Part
    function avoidNodeOverlap(node, pt, gridpt) {
        var bnds = node.actualBounds;
        var loc = node.location;

        var x = gridpt.x - (loc.x - bnds.x);
        var y = gridpt.y - (loc.y - bnds.y);

        var r = new go.Rect(x, y, bnds.width, bnds.height);

        if (isUnoccupied(r, node)) return pt;  // OK

        return loc;  // give up -- don't allow the node to be moved to the new location
    }

    var $_$ = go.GraphObject.make;


    // var nodeResizeAdornmentTemplate =
    //     $_$(go.Adornment, "Spot",
    //         {locationSpot: go.Spot.Right},
    //         $_$(go.Placeholder),
    //         $_$(go.Shape, {
    //             alignment: go.Spot.TopLeft,
    //             cursor: "nw-resize",
    //             desiredSize: new go.Size(6, 6),
    //             fill: "lightblue",
    //             stroke: "deepskyblue"
    //         }),
    //         $_$(go.Shape, {
    //             alignment: go.Spot.Top,
    //             cursor: "n-resize",
    //             desiredSize: new go.Size(6, 6),
    //             fill: "lightblue",
    //             stroke: "deepskyblue"
    //         }),
    //
    //         $_$(go.Shape, {
    //             alignment: go.Spot.Left,
    //             cursor: "w-resize",
    //             desiredSize: new go.Size(6, 6),
    //             fill: "lightblue",
    //             stroke: "deepskyblue"
    //         }),
    //
    //         $_$(go.Shape, {
    //             alignment: go.Spot.BottomLeft,
    //             cursor: "se-resize",
    //             desiredSize: new go.Size(6, 6),
    //             fill: "lightblue",
    //             stroke: "deepskyblue"
    //         })
    //     );

    myDiagram = $_$(go.Diagram, "myDiagramDiv",
        {
            mouseDrop: function (e) {
                finishDrop(e, null);
            },
            initialContentAlignment: go.Spot.Center,
            allowDrop: true,
            "commandHandler.archetypeGroupData": {isGroup: true, category: "WorkStation"},
            "undoManager.isEnabled": true,
            // when a node is selected in the main Diagram, select the corresponding tree node
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

    // when the document is modified, add a "*" to the title and enable the "Save" button
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
                        font: "bold 12pt Helvetica, Arial, sans-serif",
                        stroke: colors["black"],
                        editable: true,
                        textAlign: "center"
                    },
                    new go.Binding("text", "text").makeTwoWay())
            )
        )
    );

    // Upon a drop onto a Group, we try to add the selection as members of the Group.
    // Upon a drop onto the background, or onto a top-level Node, make selection top-level.
    // If this is OK, we're done; otherwise we cancel the operation to rollback everything.
    function finishDrop(e, grp) {
        var ok = (grp !== null
            ? grp.addMembers(grp.diagram.selection, true)
            : e.diagram.commandHandler.addTopLevelParts(e.diagram.selection, true));
        if (!ok) e.diagram.currentTool.doCancel();
    }

//    WorkStation
    myDiagram.groupTemplateMap.add("WorkStation",
        $_$(go.Group, go.Panel.Auto,
            {dragComputation: avoidNodeOverlap},
            {
                resizable: true,
                resizeObjectName: "Panel",
                // resizeAdornmentTemplate: nodeResizeAdornmentTemplate,
                ungroupable: false,
                background: "lightseagreen",
                cursor: "pointer",
                computesBoundsAfterDrag: true,
                mouseDrop: finishDrop,
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
                    alignment: go.Spot.TopRight,
                    stroke: null,
                    fill: "green",
                    margin: new go.Margin(5, 5, 0, 0),
                    desiredSize: new go.Size(20, 20)
                }),
            $_$(go.TextBlock, "P", {
                alignment: go.Spot.TopRight,
                editable: false,
                margin: new go.Margin(10, 10, 0, 0),
                font: "bold 13px sans-serif",
                stroke: colors["white"]
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
                    if (obj.background === "lightseagreen") {
                        obj.background = "dodgerblue";
                    } else {
                        obj.background = "lightseagreen";
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
                            alignment: go.Spot.Left,
                            editable: true,
                            margin: new go.Margin(5, 0, 0, 0),
                            font: "bold 16px sans-serif",
                            stroke: colors["white"]
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

            console.log('model Change   Node GroupKey')


        } else if (e.change === go.ChangedEvent.Property) {
            var treenode = myTreeView.findNodeForData(e.object);
            if (treenode !== null) treenode.updateTargetBindings();


            console.log("ChangedEvent.Property");

            if (e.mm == "text") {
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

            console.log('change insert');

            // pretend the new data isn't already in the nodeDataArray for myTreeView
            myTreeView.model.nodeDataArray.splice(e.newParam, 1);
            // now add to the myTreeView model using the normal mechanisms
            myTreeView.model.addNodeData(e.newValue);

            var NewNode = e.newValue;
            var NewParam = e.newParam;

//        if (NewNode.category == "Worker" && typeof(NewNode.group) == "undefined") {
//          $('<div>Worker should belong to WorkStation.</div>').notifyModal();
//        }

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
                    console.log("ChangeEvent  NodeDataArray")
                    console.log(data)


                    NewNode.key = data.id;
                    NewNode.text = data.name;
                    NewNode.code = data.code;
                    NewNode.node_set_id = data.node_set_id;
                },
                error: function () {
                    console.log("Something Error!");
                }
            });

//        if (NewNode.category == "WorkStation") {
//
//        } else if (NewNode.category == "Worker") {
//          $.ajax({
//            url: '/diagrams/' + DiagramID + '/nodes',
//            type: 'post',
//            dataType: 'json',
//            async: false,
//            data: {
//              node: {
//                name: NewNode.text,
//                type: Type
//              }
//            },
//            success: function (data) {
//              console.log(data);
////              NewNode.key = data.id;
////              NewNode.text = data.name;
////              NewNode.returnParams = data;
//            },
//            error: function () {
//              console.log("Something Error!");
//            }
//          });
//        }
        } else if (e.change === go.ChangedEvent.Remove && e.propertyName === "nodeDataArray") {
            console.log(' Change   Remove NodeDataArray');

            // remove the corresponding node from myTreeView
            var treenode = myTreeView.findNodeForData(e.oldValue);
            if (treenode !== null) myTreeView.remove(treenode);
        }
    });

    myPalette =
        $_$(go.Palette, "myPaletteDiv",  // must name or refer to the DIV HTML element
            {
                "animationManager.duration": 200, // slightly longer than default (600ms) animation
                nodeTemplateMap: myDiagram.nodeTemplateMap,  // share the templates used by myDiagram
                groupTemplateMap: myDiagram.groupTemplateMap,
                initialContentAlignment: go.Spot.Center,
                model: new go.GraphLinksModel([  // specify the contents of the Palette
                    {
                        category: "Worker",
                        text: "员工",
                        code: "",
                        node_set_id: ""
                    },
                    {
                        category: "WorkStation",
                        size: "80 40",
                        text: "工位",
                        background: "lightseagreen",
                        isGroup: true,
                        code: "",
                        node_set_id: ""
                    }
                ], [])
            }
        );

    myTreeView = $_$(go.Diagram, "myTreeView",
        {
            allowMove: false,  // don't let users mess up the tree
            allowCopy: false,  // but you might want this to be false
            "commandHandler.copiesTree": false,
            "commandHandler.copiesParentKey": false,
            allowDelete: false,  // but you might want this to be false
            "commandHandler.deletesTree": false,
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
                selectionAdorned: false
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
                    {font: '9pt Verdana, sans-serif'},
                    new go.Binding("text", "text", function (s) {
                        return s;
                    })
                )
            )
        )
    );

    //WorkStation
    myTreeView.nodeTemplateMap.add("WorkStation",
        $_$(go.Node,
            {
                selectionAdorned: false
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
                            fill: 'dodgerblue',
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
                        {font: '9pt Verdana, sans-serif'},
                        new go.Binding("text", "text", function (s) {
                            return s;
                        })
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

    function borderStyle() {
        return {
            fill: "white",
            stroke: "lightseagreen",
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