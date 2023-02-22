version 1.0

task myTask {
    input {
        File pyscript
    }
    command {
        echo $PWD
        python ${pyscript}
    }
    output {
        String out = read_string(stdout())
    }
}

workflow myWorkflow {
    input {
        File pyscript
    }
    call myTask {input: pyscript=pyscript}
}