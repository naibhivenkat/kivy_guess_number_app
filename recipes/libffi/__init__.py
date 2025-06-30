from pythonforandroid.recipe import AutotoolsRecipe


class LibffiRecipe(AutotoolsRecipe):
    version = '3.3'
    url = 'https://github.com/libffi/libffi/releases/download/v3.3/libffi-3.3.tar.gz'
    built_libraries = {'libffi.so': 'inst/lib'}

    def prebuild_arch(self, arch):
        super().prebuild_arch(arch)
        # libffi ships with a working `configure`, no need for autogen.sh
        autogen = self.get_build_dir(arch.arch) + '/autogen.sh'
        self.ctx.logger.info(f'Disabling autogen.sh: {autogen}')
        if os.path.exists(autogen):
            os.remove(autogen)


recipe = LibffiRecipe()
