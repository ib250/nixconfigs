#! /usr/bin/env node

const fs = require("fs")


const baseName = p => p.split('/').filter((_, ix, ar) => ix === ar.length - 1);


const whichLang = (binPath, lsp) => {

    switch (lsp) {
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

        case "metals-vim":
            return { 
                command: binPath,
                rootPatterns: ["build.sbt"],
                filetypes: ["scala", "sbt"]
            }

        case "ccls":
            return {
                command: binPath,
                rootPatterns: [
                    "compile_flags.txt",
                    "compile_commands.json",
                    ".vim/",
                    ".git/",
                    ".hg/"
                ],
                filetypes: ["c", "cpp", "objc", "objcpp"],
                initializationOptions: {
                    cache: {
                        directory: "/tmp/ccls"
                    }
                }
            }

        case "bash-language-server":
            return {
                command: binPath,
                args: ["start"],
                filetypes: ["sh"],
                ignoredRootPaths: ["~"]
            }

        case "ghcide":
            return {
                command: binPath,
                args: [ "--lsp" ],
                rootPatterns: [
                    ".stack.yaml",
                    ".hie-bios",
                    "BUILD.bazel",
                    "cabal.config",
                    "package.yaml"
                ],
                filetypes: [
                    "hs", "lhs", "haskell"
                ]
            }

        default:
            throw `
                unrecognised language server: ${lsp}
                maybe update dots?
            `
    }
}

const includeLanguageServer = (cocSettings, binPath) => {
    const settings = fs.existsSync(cocSettings)
        ? JSON.parse(fs.readFileSync(cocSettings))
        : {}

    const [ lsp ] = baseName(binPath)

    return {
        ...settings,
        languageserver: {
            ...settings.languageserver,
            [lsp]: whichLang(binPath, lsp) 
        }
    }
}

const [,, cocSettings, binPath] = process.argv
console.log(
    `
    coc settings: ${cocSettings}
    language server binary path: ${binPath}
    `
)

cocSettings && fs.writeFileSync(
    cocSettings,
    JSON.stringify(
        includeLanguageServer(cocSettings, binPath),
        null,
        4
    )
)
