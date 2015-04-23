/*
 * FCKeditor - The text editor for Internet - http://www.fckeditor.net
 * Copyright (C) 2003-2010 Frederico Caldeira Knabben
 *
 * == BEGIN LICENSE ==
 *
 * Licensed under the terms of any of the following licenses at your
 * choice:
 *
 *  - GNU General Public License Version 2 or later (the "GPL")
 *    http://www.gnu.org/licenses/gpl.html
 *
 *  - GNU Lesser General Public License Version 2.1 or later (the "LGPL")
 *    http://www.gnu.org/licenses/lgpl.html
 *
 *  - Mozilla Public License Version 1.1 or later (the "MPL")
 *    http://www.mozilla.org/MPL/MPL-1.1.html
 *
 * == END LICENSE ==
 */

/**
 * @author 4what
 * @version
 */
// Register the related commands.
FCKCommands.RegisterCommand("UploadImg", new FCKDialogCommand("UploadImg", "上传图片", /*FCKConfig.PluginsPath*/FCKConfig.plugin.path + "uploadimg/uploadimg.html", 320, 320));

// Create the "" toolbar button.
var oFindItem = new FCKToolbarButton("UploadImg", " ", "上传图片", FCK_TOOLBARITEM_ICONTEXT);
oFindItem.IconPath = /*FCKConfig.PluginsPath*/FCKConfig.plugin.path + "uploadimg/uploadimg.png";

FCKToolbarItems.RegisterItem("UploadImg", oFindItem);
