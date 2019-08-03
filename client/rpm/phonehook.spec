# 
# Do NOT Edit the Auto-generated Part!
# Generated by: spectacle version 0.27
# 

Name:       phonehook

# >> macros
# << macros

%{!?qtc_qmake:%define qtc_qmake %qmake}
%{!?qtc_qmake5:%define qtc_qmake5 %qmake5}
%{!?qtc_make:%define qtc_make make}
%{?qtc_builddir:%define _builddir %qtc_builddir}
Summary:    Phonehook
Version:    0.7.2
Release:    1
Group:      Qt/Qt
License:    GPLv3
URL:        https://github.com/omnight/phonehook
Source0:    %{name}-%{version}.tar.bz2
Source100:  phonehook.yaml
Requires:   sailfishsilica-qt5 >= 0.10.9
Requires:   sailfish-version >= 3.0.0
BuildRequires:  pkgconfig(sailfishapp) >= 1.0.2
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  pkgconfig(Qt5DBus)
BuildRequires:  desktop-file-utils
BuildRequires:  systemd

%description
See who's calling!

%prep
%setup -q -n %{name}-%{version}

# >> setup
# << setup

%build
%qtc_qmake5
%qtc_make %{?_smp_mflags}

%postun
# >> postun
if [ "$1" -eq 0 ]; then
killall phonehook-daemon || :
killall phonehook || true
systemctl-user disable phonehook-daemon.service || :
rm /usr/lib/systemd/user/post-user-session.target.wants/phonehook-daemon.service
fi
systemctl-user daemon-reload || :
# << postun

%posttrans
# >> posttrans
killall phonehook-daemon || :
ln -s -f /usr/lib/systemd/user/phonehook-daemon.service /usr/lib/systemd/user/post-user-session.target.wants
systemctl-user enable phonehook-daemon.service || :
systemctl-user daemon-reload || :
# << posttrans

%install
rm -rf %{buildroot}
# >> install pre
# << install pre
%qmake5_install

# >> install post
# << install post

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop

%files
%defattr(-,root,root,-)
%{_bindir}
%{_datadir}/%{name}
%{_datadir}/%{name}-daemon
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/86x86/apps/%{name}.png
/usr/lib/systemd/user/phonehook-daemon.service
# >> files
# << files
