import QtQuick 2.2
import mywindow 1.0
import utility 1.0
import "../"
import "../../QQItemInfo"
import "../../Utility"

Item{
    id: root
    clip: true
    
    function getGroupListFinished( error, data ) {
        if(error){
            myqq.getGroupList(getGroupListFinished) //获取群列表
            return
        }
        
        data = JSON.parse(data)
        if(data.retcode ==0 ) {
            var groupmarknames = data.result.gmarklist//群备注信息
            var i=0;
            for( i=0; i<groupmarknames.length;++i ) {
                var newObject = Qt.createQmlObject('import QQItemInfo 1.0; GroupInfo{userQQ:'+myqq.userQQ+';uin:'+marknames[i].uin+'}')
                newObject.alias = groupmarknames[i].markname
            }
            var list_info = data.result.gnamelist
            for( i=0; i< list_info.length;++i ) {
                mymodel.append({"obj_info": list_info[i]})
            }
        }
    }
    Component.onCompleted: {
        myqq.getGroupList(getGroupListFinished)
    }
    MyScrollView{
        anchors.fill: parent
        Item{
            height: list.contentHeight+10
            width: root.width
            implicitHeight: height
            implicitWidth: width
            ListView{
               id: list
               interactive: false
               anchors.fill: parent
               model: ListModel{
                   id:mymodel
               }
               spacing :10
               delegate: component
            }
        }
    }
    
    Component{
        id: component
        Item{
            width: parent.width
            height: avatar.height
            property var info: obj_info
            DiscuInfo{
                id: myinfo
                uin: parent.info.gid
                nick: parent.info.name
            }

            MyImage{
                id: avatar
                x:10
                width:40
                maskSource: "qrc:/images/bit.bmp"
                source: myinfo.avatar40
                onLoadError: {
                    myinfo.avatar40 = "qrc:/images/avatar.png"
                }
            }
            Text{
                id:text_nick
                anchors.top: avatar.top
                anchors.left: avatar.right
                anchors.leftMargin: 10
                font.pointSize: 14
                text: myinfo.aliasOrNick
            }
            MouseArea{
                anchors.fill: parent
                onDoubleClicked: {
                    chat_command.addChat(myinfo.uin, GroupInfo.Discu)
                }
            }
        }
    }    
}
