# -*- coding:utf-8 -*-

#./autobuild.py -p youproject.xcodeproj -s schemename
#./autobuild.py -w youproject.xcworkspace -s schemename

import argparse
import subprocess
#import requests
import os

#配置iOS Build
CONFIGURATION = "Release" # "Debug"
EXPORT_OPTIONS_PLIST = "exportOptions.plist"

#企业(enterprise)证书名 #描述文件
#会在桌面的TCLeaderTool 文件夹下输出ipa的文件目录
EXPORT_MAIN_DIRECTORY = "~/Desktop/TCLeaderTool/"

#清理项目 创建build目录
def cleanArchiveFile(archiveFile):
    cleanCmd = "rm -r %s" %(archiveFile)
    process = subprocess.Popen(cleanCmd, shell = True)
    process.wait()
    print "cleaned archiveFile: %s" %(archiveFile)

#创建输出ipa文件路径： ~/Desktop/{scheme}{2016-12-28_08-08-10}
def buildExportDirectory(scheme):
    dateCmd = 'date "+%Y-%m-%d_%H-%M-%S"'
    process = subprocess.Popen(dateCmd, stdout=subprocess.PIPE, shell=True)
    (stdoutdata, stderrdata) = process.communicate()
    exportDirectory = "%s%s%s" %(EXPORT_MAIN_DIRECTORY, scheme, stdoutdata.strip())
    return exportDirectory

#构建归档路径
def buildArchivePath(tempName):
    process = subprocess.Popen("pwd", stdout=subprocess.PIPE)
    (stdoutdata, stderrdata) = process.communicate()
    archiveName = "%s.xcarchive" %(tempName)
    archivePath = stdoutdata.strip() + '/' + archiveName
    return archivePath

#获取IPA路径
def getIPAPath(exportPath):
    cmd = "ls %s" %(exportPath)
    process = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)
    (stdoutdata, stderrdata) = process.communicate()
    ipaName = stdoutdata.strip()
    ipaPath = exportPath + "/" + ipaName
    return ipaPath

#导出归档文件
def exportArchive(scheme, archivePath):
    exportDirectory = buildExportDirectory(scheme)
    exportCmd = "xcodebuild -exportArchive -archivePath %s -exportPath %s -exportOptionsPlist %s" %(archivePath, exportDirectory, EXPORT_OPTIONS_PLIST)
    process = subprocess.Popen(exportCmd, shell=True)
    (stdoutdata, stderrdata) = process.communicate()
    signReturnCode = process.returncode
    if signReturnCode  != 0:
        print "export %s failed" %(scheme)
        return ""
    else:
        return exportDirectory

#构建Project
def buildProject(project, scheme):
    archivePath = buildArchivePath(scheme)
    print "archivePath: " + archivePath
    #archiveCmd = 'xcodebuild -project %s -scheme %s -configuration %s archive -archivePath %s build CODE_SIGN_IDENTITY="%s" PROVISIONING_PROFILE="%s" -destination generic/platform=iOS ' %(project, scheme, CONFIGURATION, archivePath, ENTERPRISECODE_SIGN_IDENTITY, ENTERPRISEROVISIONING_PROFILE_NAME)
    archiveCmd = 'xcodebuild -project %s -scheme %s -configuration %s archive -archivePath %s -destination generic/platform=iOS ' %(project, scheme, CONFIGURATION, archivePath)
    process = subprocess.Popen(archiveCmd, shell=True)
    process.wait()
    archiveReturnCode = process.returncode
    if archiveReturnCode != 0:
        print "archive project %s failed" %(project)
        cleanArchiveFile(archivePath)
    else:
        exportDirectory = exportArchive(scheme, archivePath)
        cleanArchiveFile(archivePath)
        if exportDirectory != "":
            ipaPath = getIPAPath(exportDirectory)
# uploadIpaToPgyer(ipaPath)

#构建Workspace
def buildWorkspace(workspace, scheme):
    archivePath = buildArchivePath(scheme)
    print "archivePath: " + archivePath
    archiveCmd = 'xcodebuild -workspace %s -scheme %s -configuration %s archive -archivePath %s -destination generic/platform=iOS' %(workspace, scheme, CONFIGURATION, archivePath)
    process = subprocess.Popen(archiveCmd, shell=True)
    process.wait()
        
    archiveReturnCode = process.returncode
    if archiveReturnCode != 0:
        print "archive workspace %s failed" %(workspace)
        cleanArchiveFile(archivePath)
    else:
        exportDirectory = exportArchive(scheme, archivePath)
        cleanArchiveFile(archivePath)
        if exportDirectory != "":
            ipaPath = getIPAPath(exportDirectory)
#   uploadIpaToPgyer(ipaPath)

#xcbuild main
def xcbuild(options):
    project = options.project
    workspace = options.workspace
    scheme = options.scheme

    if project is None and workspace is None:
        pass
    elif project is not None:
        buildProject(project, scheme)
    elif workspace is not None:
        buildWorkspace(workspace, scheme)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-w", "--workspace", help="Build the workspace name.xcworkspace.", metavar="name.xcworkspace")
    parser.add_argument("-p", "--project", help="Build the project name.xcodeproj.", metavar="name.xcodeproj")
    parser.add_argument("-s", "--scheme", help="Build the scheme specified by schemename. Required if building a workspace.", metavar="schemename")
    options = parser.parse_args()
    print "options: %s" % (options)
    xcbuild(options)

if __name__ == '__main__':
    main()








