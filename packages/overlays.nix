let

  ib250 = final: prev: {

    ib250 = let

      readTOML = p: builtins.fromTOML (builtins.readFile p);

      unlines = strings:
        with prev.lib;
        concatStrings (intersperse "\n" strings);

      unwords = strings:
        with prev.lib;
        concatStrings (intersperse " " strings);

      poetryRunScript = name: cmd:
        prev.writeScriptBin name ''
          ${final.poetry}/bin/poetry run ${cmd}
        '';

      poetryRunPoe = name: cmd: poetryRunScript name ''poe ${cmd} "$@"'';

      poeTask = task: poetryRunPoe task task;

      attrByDotPath = path: default:
        prev.lib.attrByPath (prev.lib.splitString "." path) default;

    in {

      inherit readTOML unlines poetryRunScript poetryRunPoe poeTask
        attrByDotPath;

      mkPoetryDevEnv = attrs@{ src, extraPythonPackages, ... }:
        let

          pyproject = readTOML (src + "/pyproject.toml");

          pipInstalls = unwords extraPythonPackages;

          poeTasks = with prev.lib; let
            tasks = attrNames (attrByDotPath "tool.poe.tasks" { } pyproject);
            main-tasks = lists.filter (s: !(hasPrefix "_" s)) tasks;
          in lists.map poeTask main-tasks;

          buildInputs = [ final.poetry ] ++ poeTasks
            ++ (attrByDotPath "buildInputs" [ ] attrs);

          project = attrByDotPath "tool.poetry.name" "<unknown>" pyproject;

        in prev.mkShell {
          inherit buildInputs;
          shellHook = ''
            ${final.poetry}/bin/poetry install -v
            ${final.poetry}/bin/poetry run pip install ${pipInstalls}
            echo "project: ${project}"
          '';
        };

    };

  };

in [ ib250 ]
