#!/bin/bash


echo $TERRAFORM_WORKSPACE
echo TERRAFORM_ROOT_MODULE


make $TERRAFORM_COMMAND

if grep -q "no changes are needed" "$TERRAFORM_ROOT_MODULE/$TERRAFORM_ROOT_MODULE-$TERRAFORM_WORKSPACE.md"
    then
        echo 'NO CHANGES'
        buildkite-agent annotate --context "$TERRAFORM_ROOT_MODULE-$TERRAFORM_WORKSPACE" --style info < ${TERRAFORM_ROOT_MODULE}/${TERRAFORM_ROOT_MODULE}-${TERRAFORM_WORKSPACE}.md
    else
        echo 'CHANGES IDENTIFIED'
        buildkite-agent annotate --context "$TERRAFORM_ROOT_MODULE-$TERRAFORM_WORKSPACE" --style warning < ${TERRAFORM_ROOT_MODULE}/${TERRAFORM_ROOT_MODULE}-${TERRAFORM_WORKSPACE}.md
fi