# Mecurial to Mecurial converter

I had forked a TFS repository from CodePlex, and by _forked_ I mean I used git-svn so I could use a **real** VCS. Now the maintainer has moved to mecurial so I could merge easier. When I went to convert my git history into a mecurial repository it converted smoothly except HG couldn't find a common ancestor. 

I am creating this utility to take two similar mecurial repositories, explicitly say what the last common revision is, and fold one repo into the other.

Yes, I understand the irony of committing an hg2hg tool into a git repository. But that's how I roll...