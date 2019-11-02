#! /usr/bin/env node

const fs = require("fs")


const whichLang = (binPath, ls) => {
    switch (ls) {
        case "clangd":
            return {
                command: binPath,
                args: ["--background-index"],
                rootPatterns: [
                    "compile_flags.txt",
                    "compile_commands.json",
                    ".vim/",
                    ".git/",
                    ".hg/"
                ],
                filetypes: ["c", "cpp", "objc", "objcpp"]
            }
        case "metals":
            return { 
                command: binPath,
                rootPatterns: ["build.sbt"],
                filetypes: ["scala", "sbt"]
            }
        default:
            throw "unrecognised language server, maybe update dots?"
    }
}

const includeLanguageServer = (cocSettings, binPath, languageServer) => {
    const settings = fs.existsSync(cocSettings)
        ? JSON.parse(fs.readFileSync(cocSettings))
        : {}

    return {
        ...settings,
        languageServer: {
            ...settings.languageServer,
            [languageServer]: whichLang(binPath, languageServer) 
        }
    }
}

const [,, cocSettings, binPath, languageServer] = process.argv
console.log(
    `
    coc settings: ${cocSettings}
    ${languageServer} language server binary path: ${binPath}
    `
)

cocSettings && fs.writeFileSync(
    cocSettings,
    JSON.stringify(
        includeLanguageServer(
            cocSettings,
            binPath,
            languageServer
        ),
        null,
        4
    )
)
